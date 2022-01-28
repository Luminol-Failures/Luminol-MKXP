class ColorPicker
  def initialize(rect, options = {})
    @rect = rect
    @color = options[:color]
    @color ||= Color.new(255, 255, 255)

    @red = @color.red
    @green = @color.green
    @blue = @color.blue

    @old_red = @red
    @old_green = @green
    @old_blue = @blue

    @selected = false

    @dragging = false
    @dragging_bar = :red
    @drag_x = 0
    @drag_y = 0
  end

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in button

      if @selected || @dragging
        column_width = @rect.width / 4 - 5 # - 2 For padding
        red_x = self.x + window.x + 16 + column_width + 8
        green_x = self.x + window.x + 16 + column_width * 2 + 12
        blue_x = self.x + window.x + 16 + column_width * 3 + 16

        all_y = self.y + window.y + 4 + 16
        all_end_y = self.y + window.y + 16 + @rect.height - 8

        if Input.trigger?(Input::MOUSELEFT)
          if mx >= red_x && mx <= red_x + column_width && my >= all_y && my <= all_end_y
            @dragging_bar = :red
            @drag_x = mx - red_x
            @drag_y = my - all_y
            @dragging = true
          end

          if mx >= green_x && mx <= green_x + column_width && my >= all_y && my <= all_end_y
            @dragging_bar = :green
            @drag_x = mx - green_x
            @drag_y = my - all_y
            @dragging = true
          end

          if mx >= blue_x && mx <= blue_x + column_width && my >= all_y && my <= all_end_y
            @dragging_bar = :blue
            @drag_x = mx - blue_x
            @drag_y = my - all_y
            @dragging = true
          end
        end

        if @dragging && Input.press?(Input::MOUSELEFT)
          height_ratio = (@rect.height - 8) / 255.0
          value = 255 - (my - self.y - window.y - 16 - 4) / height_ratio
          value = value.clamp(0, 255)
          case @dragging_bar
          when :red
            @red = value
          when :green
            @green = value
          when :blue
            @blue = value
          end
          @color.red = @red
          @color.green = @green
          @color.blue = @blue

          if @blue != @old_blue || @green != @old_green || @red != @old_red
            @old_blue = @blue
            @old_green = @green
            @old_red = @red
            window.draw
          end
        elsif @dragging
          @dragging = false
          @color_block.call(@color) if @color_block
        end
      end
    else
      @selected = false
      return
    end
  end

  def draw(bitmap)
    src_bitmap = Bitmap.new(@rect.width, @rect.height)
    column_width = @rect.width / 4 - 5 # - 2 For padding

    red = Color.new(@red, 0, 0)
    green = Color.new(0, @green, 0)
    blue = Color.new(0, 0, @blue)
    black = Color.new(0, 0, 0)
    white = Color.new(255, 255, 255)

    src_bitmap.fill_rect(0, 0, @rect.width, @rect.height, Color.new(48, 48, 48))
    src_bitmap.fill_rect(4, 4, column_width, column_width, @color)
    src_bitmap.font = bitmap.font
    src_bitmap.font.size = 18

    r_width = src_bitmap.text_size(@red.to_i.to_s).width
    text_height = src_bitmap.text_size(@red.to_i.to_s).height
    src_bitmap.font.color = red
    src_bitmap.draw_text(
      Rect.new(4, column_width + 4, r_width, text_height),
      @red.to_i.to_s
    )

    g_width = src_bitmap.text_size(@green.to_i.to_s).width
    src_bitmap.font.color = green
    src_bitmap.draw_text(
      Rect.new(4, column_width + text_height + 4, g_width, text_height),
      @green.to_i.to_s
    )

    b_width = src_bitmap.text_size(@blue.to_i.to_s).width
    src_bitmap.font.color = blue
    src_bitmap.draw_text(
      Rect.new(4, column_width + text_height * 2 + 4, b_width, text_height),
      @blue.to_i.to_s
    )

    src_bitmap.gradient_fill_rect(
      Rect.new(column_width + 8, 4, column_width, @rect.height - 8),
      red,
      black,
      true
    )
    src_bitmap.gradient_fill_rect(
      Rect.new(column_width * 2 + 12, 4, column_width, @rect.height - 8),
      green,
      black,
      true
    )
    src_bitmap.gradient_fill_rect(
      Rect.new(column_width * 3 + 16, 4, column_width, @rect.height - 8),
      blue,
      black,
      true
    )

    height_ratio = (@rect.height - 8) / 255.0
    src_bitmap.fill_rect(
      Rect.new(column_width + 8, (255 - @red) * height_ratio + 4, column_width, 2),
      white
    )
    src_bitmap.fill_rect(
      Rect.new(column_width * 2 + 12, (255 - @green) * height_ratio + 4, column_width, 2),
      white
    )
    src_bitmap.fill_rect(
      Rect.new(column_width * 3 + 16, (255 - @blue) * height_ratio + 4, column_width, 2),
      white
    )

    bitmap.blt(@rect.x, @rect.y, src_bitmap, Rect.new(0, 0, @rect.width, @rect.height))
  end

  def on_color_changed(&block)
    @color_block = block
  end

  def selected?
    return @selected
  end

  def width
    return @rect.width
  end

  def height
    return @rect.height
  end

  def x
    return @rect.x
  end

  def y
    return @rect.y
  end

  def inside?(window, x, y)
    x1 = @rect.x + window.x + 16
    y1 = @rect.y + window.y + 16
    x2 = @rect.x + @rect.width + window.x + 16
    y2 = @rect.y + @rect.height + window.y + 16

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end
end
