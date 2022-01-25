class TextInput
  def initialize(rect, options)
    @rect = rect
    @hint_text = options[:hint_text]
    @hint_text ||= ""
    @text = ""
    @selected = false

    @font_size = options[:font_size]
    @font_size ||= 16

    @active = false

    @selected_text = ""

    @cursor_timer = 0

    @text_limit = options[:text_limit]
    @text_limit ||= 255

    @old_text = ""

    @cursor_pos = 1
    @cursor_override = false
  end

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in textinput

      if Input.trigger?(Input::MOUSELEFT) && @selected
        @active = true
        Input.start_text_input(@text_limit)
        Input.set_text_input(@text)
        @click_block.call(@text) if @click_block
      elsif Input.trigger?(Input::MOUSELEFT) && @active
        @active = false
        Input.stop_text_input
        @finish_block.call(@text) if @finish_block
      end
    end

    if @active
      @text = Input.text_input
    end

    #if Input.trigger?(Input::KEY_RETURN)
    #  @text += "\n"
    #  Input.set_text_input(@text)
    #end

    if @text != @old_text
      @old_text = @text
      window.draw
    end

    if Input.repeat?(Input::RIGHT)
      @cursor_pos += 1 unless @cursor_pos >= @text.length
      window.draw
    elsif Input.repeat?(Input::LEFT)
      @cursor_pos -= 1 unless @cursor_pos <= 1
      window.draw
    end

    @cursor_timer += 1
    @cursor_timer %= 30 # Make the cursor blink every 30 frames
    window.draw if @active && @cursor_timer == 0
  end

  def inside?(window, x, y)
    x1 = @rect.x + window.x + 16
    y1 = @rect.y + window.y + 16
    x2 = @rect.x + @rect.width + window.x + 16
    y2 = @rect.y + @rect.height + window.y + 16

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end

  def draw(bitmap)
    outside_color = $system.border_color
    inside_color = $system.interior_color
    spacing = 3

    outside_rect = Rect.new(
      @rect.x + spacing,
      @rect.y + spacing,
      @rect.width - spacing * 2,
      @rect.height - spacing * 2
    )
    bitmap.fill_rect(outside_rect, outside_color)

    inside_rect = Rect.new(
      @rect.x + spacing * 2,
      @rect.y + spacing * 2,
      @rect.width - spacing * 4,
      @rect.height - spacing * 4
    )
    bitmap.fill_rect(inside_rect, inside_color)

    if @text != ""
      char_width = bitmap.text_size(@text[0]).width
      char_height = bitmap.text_size(@text[0]).height
      text = @text.wrap((inside_rect.width - 4) / char_width)
      line = 0
      index = 0
      text.each_char.with_index do |char, total_index|
        if char == "\n"
          line += 1
          index = 0
          next
        end

        x = inside_rect.x + 2 + (index * char_width)
        y = inside_rect.y + 2 + (line * char_height)
        bitmap.draw_text(x, y, char_width, char_height, char, 1)
        index += 1
      end
    else
      bfont = bitmap.font

      font = Font.new("Terminus (TTF)", @font_size)
      font.color = Color.new(48, 48, 48)
      bitmap.font = font

      size = bitmap.text_size(@hint_text)
      bitmap.draw_text(
        @rect.x + spacing * 3,
        @rect.y + spacing * 2,
        size.width,
        size.height,
        @hint_text
      )

      bitmap.font = bfont
    end
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

  def on_click(&block)
    @click_block = block
  end

  def on_finish(&block)
    @finish_block = block
  end

  def selected?
    @selected || @active
  end
end

class String
  def wrap(width = 80)
    gsub(/(.{1,#{width}})( +|$\n?)|(.{1,#{width}})/, "\\1\\3\n")
  end
end
