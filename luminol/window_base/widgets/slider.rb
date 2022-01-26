class Slider
  attr_accessor :value # Allow other widgets to set the value

  def initialize(rect, options = {})
    @rect = rect

    @minimum = options[:minimum]
    @minimum ||= 0
    @maximum = options[:maximum]
    @maximum ||= 100

    @major_tick = options[:major_tick]
    @major_tick ||= 10
    @minor_tick = options[:minor_tick]
    @minor_tick ||= 5
    # -1 means no tick

    @value = options[:value]
    @value ||= 100

    @horizontal = options[:horizontal]
    @horizontal ||= false

    @reversed = options[:reversed]
    @reversed ||= false

    @snap = options[:snap]
    @snap ||= true

    @selected = false
    @dragging = false
    @drag_x = 0
    @drag_y = 0

    @old_value = @value
  end

  def draw(bitmap)
    src_bitmap = Bitmap.new(self.width, self.height)

    w_width = self.width - 8
    w_height = self.height - 8
    if @horizontal
      icon = $system.slider(true)

      range = @maximum - @minimum
      scale = w_width / range.to_f # How many units per pixel
      # Draw tick marks
      range.times do |i|
        width, height = 1, 8 if i % @minor_tick == 0 && @minor_tick > 0
        width, height = 2, 16 if i % @major_tick == 0 && @major_tick > 0
        next unless height
        src_bitmap.fill_rect(
          Rect.new(
            i * scale + 6,
            8,
            width,
            height
          ),
          Color.new(255, 255, 255)
        )
      end

      if @reversed
        src_bitmap.blt(
          (self.value - @minimum) * scale - 1,
          4,
          icon,
          Rect.new(0, 0, 16, 16)
        )
      else
        src_bitmap.blt(
          (@maximum - self.value) * scale - 1,
          4,
          icon,
          Rect.new(0, 0, 16, 16)
        )
      end
    else
      icon = $system.slider

      range = @maximum - @minimum
      scale = w_height / range.to_f # How many units per pixel
      # Draw tick marks
      range.times do |i|
        width, height = 8, 1 if i % @minor_tick == 0 && @minor_tick > 0
        width, height = 16, 2 if i % @major_tick == 0 && @major_tick > 0
        next unless width # Go to next if width is not set
        src_bitmap.fill_rect(
          Rect.new(
            8,
            i * scale + 6,
            width,
            height
          ),
          Color.new(255, 255, 255)
        )
      end

      if @reversed
        src_bitmap.blt(
          4,
          (self.value - @minimum) * scale - 1,
          icon,
          Rect.new(0, 0, 16, 16)
        )
      else
        src_bitmap.blt(
          4,
          (@maximum - self.value) * scale - 1,
          icon,
          Rect.new(0, 0, 16, 16)
        )
      end
    end

    bitmap.fill_rect(Rect.new(self.x, self.y, self.width, self.height), Color.new(48, 48, 48))
    bitmap.blt(self.x, self.y, src_bitmap, Rect.new(0, 0, self.width, self.height))
  end

  # ALL HAIL THE SPAGHETTI GODS

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my)

      if @dragging || @selected
        w_width = self.width - 8
        w_height = self.height - 8
        if @horizontal
          range = @maximum - @minimum
          scale = w_width / range.to_f # How many units per pixel

          slider_y = self.y + window.y + 4
          if @reversed
            slider_x = self.x + window.x + 16 + ((self.value - @minimum) * scale - 1)

            x1 = slider_x
            x2 = slider_x + 16
            y1 = slider_y
            y2 = slider_y + 32

            if mx >= x1 && mx <= x2 && my >= y1 && my <= y2 && Input.trigger?(Input::MOUSELEFT)
              @dragging = true
              @drag_x = mx - x1
              @drag_y = my - y1
            end

            if Input.press?(Input::MOUSELEFT) && @dragging
              @value = @minimum + ((mx - @drag_x - self.x - window.x - 16) / scale).to_i
            else
              @dragging = false
              @on_change.call(@value) if @on_change
            end
          else
            slider_x = self.x + window.x + 16 + ((@maximum - self.value) * scale - 1)

            x1 = slider_x
            x2 = slider_x + 16
            y1 = slider_y
            y2 = slider_y + 32

            if mx >= x1 && mx <= x2 && my >= y1 && my <= y2 && Input.trigger?(Input::MOUSELEFT)
              @dragging = true
              @drag_x = mx - x1
              @drag_y = my - y1
            end

            if Input.press?(Input::MOUSELEFT) && @dragging
              @value = @maximum - ((mx - self.x - window.x - 16 - @drag_x) / scale).to_i
            else
              @dragging = false
              @on_change.call(@value) if @on_change
            end
          end
        else
          range = @maximum - @minimum
          scale = w_height / range.to_f # How many units per pixel

          slider_x = self.x + window.x + 16 + 4
          if @reversed
            slider_y = self.y + window.y + 16 + ((self.value - @minimum) * scale - 1)

            x1 = slider_x
            x2 = slider_x + 16
            y1 = slider_y
            y2 = slider_y + 16

            if mx >= x1 && mx <= x2 && my >= y1 && my <= y2 && Input.trigger?(Input::MOUSELEFT)
              @dragging = true
              @drag_x = mx - x1
              @drag_y = my - y1
            end

            if Input.press?(Input::MOUSELEFT) && @dragging
              @value = @minimum + ((my - self.y - window.y - 16 - @drag_y) / scale).to_i
            else
              @dragging = false
              @on_change.call(@value) if @on_change
            end
          else
            slider_y = self.y + window.y + 16 + ((@maximum - self.value) * scale - 1)

            x1 = slider_x
            x2 = slider_x + 16
            y1 = slider_y
            y2 = slider_y + 16

            if mx >= x1 && mx <= x2 && my >= y1 && my <= y2 && Input.trigger?(Input::MOUSELEFT)
              @dragging = true
              @drag_x = mx - x1
              @drag_y = my - y1
            end

            if Input.press?(Input::MOUSELEFT) && @dragging
              @value = @maximum - ((my - self.y - window.y - 16 - @drag_y) / scale).to_i
            else
              @dragging = false
              @on_change.call(@value) if @on_change
            end
          end
        end
      end
    else
      @selected = @dragging
    end

    if @old_value != @value
      if @snap
        if @minor_tick > 1
          @value = (@value.to_f / @minor_tick).to_i * @minor_tick
        elsif @major_tick > 1
          @value = (@value.to_f / @major_tick).to_i * @major_tick
        end
      end

      @value = @maximum if @value > @maximum
      @value = @minimum if @value < @minimum
      window.draw
      @old_value = @value
    end
  end

  def on_change(&block)
    @on_change = block
  end

  def selected?
    @selected
  end

  def width
    @rect.width
  end

  def height
    @rect.height
  end

  def x
    @rect.x
  end

  def y
    @rect.y
  end

  def inside?(window, x, y)
    x1 = self.x + window.x + 16
    y1 = self.y + window.y + 16
    x2 = x1 + self.width
    y2 = y1 + self.height

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end
end
