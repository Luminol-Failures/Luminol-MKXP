class List
    attr_accessor :ox, :oy
    attr_accessor :clipped_region

    def initialize(rect, items, options  = {})
        @items = items
        @padding = options[:padding]
        @padding ||= 2
        @item_height = options[:item_height]
        @item_height ||= 18
        @item_height += @padding

        @min_height = options[:min_height]
        @min_height ||= 256

        @min_width = options[:min_width]
        @min_width ||= 64

        @x, @y = rect.x, rect.y
        @font = options[:font]
        @font ||= Font.new(
            Font.default_name,
            @item_height - 8,
        )

        @selected = false
        @index = options[:index]
        @index ||= 0

        @ox = @oy = 0

        @clipped_region = nil
    end

    def update(window)
        if MKXP.mouse_in_window
            mx = Input.mouse_x
            my = Input.mouse_y
      
            @selected = inside?(window, mx, my) # Check if mouse is in list
        
            if Input.trigger?(Input::MOUSELEFT) && @selected
                @index = (
                    (my - self.y - window.y - 16 + @oy) / @item_height
                )
                @block.call(@index) if @block
                window.draw
            end
        else
            @selected = false
            return
        end
    end

    def draw(bitmap)
        width = self.width
        bfont = bitmap.font
        bitmap.font = @font
        (self.height / @item_height).times do |i|
            rect = Rect.new(0, @item_height * i, width, @item_height)
            color = Color.new(0, 0, 0) if i.even?
            color  = Color.new(40, 40, 40) if i.odd?
            color  = Color.new(color.red + 80, color.green, color.blue + 100) if @index == i

            bitmap.fill_rect(rect, color)
            text = @items[i]
            bitmap.draw_text(rect, text) if text

            border_color = Color.new(128, 128, 128)
            rect.height = @padding
            rect.y = @item_height * (i + 1) - @padding

            bitmap.fill_rect(rect, border_color)
        end
        bitmap.font = bfont
    end

    def on_select(&block)
        @block = block
    end

    def selected?
        return @selected
    end

    def x
        @x
    end

    def y
        @y
    end

    def width
        calculate_size.width
    end

    def height
        calculate_size.height
    end

    def calculate_size
        rect = Rect.new(@x, @y, 0, 0)
        # Temporary bitmap for text size calculation
        b = Bitmap.new(1, 1)
        b.font = @font

        if @items.size == 0
            rect.width = @min_width
            rect.height = @min_height
            return rect
        end

        rect.height = @items.size * @item_height
        rect.width = b.text_size(@items.max_by(&:length)).width
    
        if rect.width < @min_width
            rect.width = @min_width
        end
        if rect.height < @min_height
            rect.height = @min_height
        end

        b.dispose

        return rect
    end

    def inside?(window, x, y)
        if @clipped_region
            x1 = @clipped_region.x + window.x + 16
            y1 = @clipped_region.y + window.y + 16
            x2 = x1 + @clipped_region.width
            y2 = y1 + @clipped_region.height
        else
            x1 = self.x + window.x + 16
            y1 = self.y + window.y + 16
            x2 = x1 + self.width
            y2 = y1 + self.height
        end
    
        return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
    end
end