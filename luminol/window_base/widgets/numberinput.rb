class NumberInput
  def initialize(rect, options = {})
    @rect = rect
    @rect.height = 32 # Always force height to 32

    @value = options[:value]
    @value ||= 0

    @manual_value = ""
    @active = false
    @maximum = options[:maximum]
    @maximum ||= 255
    @minimum = options[:minimum]
    @minimum ||= 0
  end

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in textinput

      x1 = self.x + window.x + 16 + (self.width - 20)
      x2 = self.x + self.width + window.x + 16
      y1 = self.y + window.y + 16
      y2 = y1 + self.height

      if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) # If in non manual input area
        y1 = self.y + window.y + 16 + 16
        if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) && Input.trigger?(Input::MOUSELEFT) # Down
          @value -= 1
          @value = @minimum if @value < @minimum
          @on_change.call(@value) if @on_change
          window.draw
        end

        y1 = self.y + window.y + 16
        y2 = y1 + 16
        if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) && Input.trigger?(Input::MOUSELEFT) # Up
          @value += 1
          @value = @maximum if @value > @maximum
          @on_change.call(@value) if @on_change
          window.draw
        end

        return
      end

      # So we dont have to do this when not active
      if @active
        @manual_value = Input.text_input
        if @manual_value =~ /[^0-9\-]/ # Check if manual value is not a number or a negative number
          @manual_value.gsub!(/[^0-9\-]/, "") # Remove non-numeric characters
          Input.set_text_input(@manual_value)
        end
        # We need to check if the value is different
        # If it is, we need to update the value, and redraw the window
        # We dont need to redraw the window constantly, as it is expensive
        if @value != @manual_value.to_i
          @value = @manual_value.to_i # Set value to manual value

          if @value > @maximum || @value < @minimum
            @value = @value.clamp(@minimum, @maximum)
            @manual_value = @value.to_s
            Input.set_text_input(@manual_value)
          end
          window.draw
        end
      end

      if Input.trigger?(Input::MOUSELEFT) && @selected
        @active = true
        Input.start_text_input(10)
        Input.set_text_input(@value.to_s)
      elsif Input.trigger?(Input::MOUSELEFT) && @active
        @active = false
        Input.stop_text_input
        @on_change.call(@value) if @on_change
      end
    else
      @selected = false
    end
  end

  def draw(bitmap)
    title_pieces = []
    8.times do |i|
      title_pieces << $system.titlebar_element(i)
    end

    src_rect = Rect.new(0, 0, 16, 16)
    src_bitmap = Bitmap.new(self.width, self.height)
    src_bitmap.font = Font.new(Font.default_name, 20)
    2.times do |i|
      src_bitmap.blt(0, i * 16, title_pieces[0 + (i * 4)], src_rect)
      src_bitmap.stretch_blt(
        Rect.new(16, i * 16, self.width / 2 - 16, 16),
        title_pieces[1 + (i * 4)],
        src_rect
      )
      src_bitmap.stretch_blt(
        Rect.new(self.width / 2, i * 16, self.width / 2 - 16, 16),
        title_pieces[2 + (i * 4)],
        src_rect
      )
      src_bitmap.blt(self.width - 16, i * 16, title_pieces[3 + (i * 4)], src_rect)
    end
    src_bitmap.draw_text(
      Rect.new(8, 0, self.width, self.height),
      @value.to_s,
    )
    up = $system.button(:up)
    down = $system.button(:down)
    src_bitmap.blt(self.width - 20, 0, up, src_rect)
    src_bitmap.blt(self.width - 20, 16, down, src_rect)

    bitmap.blt(self.x, self.y, src_bitmap, Rect.new(0, 0, self.width, self.height))
  end

  def on_change(&block)
    @on_change = block
  end

  def selected?
    @selected || @active
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

  def value
    return @value
  end

  def value=(value)
    @value = value
    @manual_value = value.to_s
    Input.set_text_input(@manual_value) if @active
  end

  def inside?(window, x, y)
    x1 = self.x + window.x + 16
    y1 = self.y + window.y + 16
    x2 = x1 + self.width
    y2 = y1 + self.height

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end
end
