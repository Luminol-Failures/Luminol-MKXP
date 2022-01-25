class Button
  def initialize(rect, type, options = {})
    @rect = rect
    @state = false
    @selected = false
    @options = options
    @type = type
  end

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in button

      if @selected
        if Input.trigger?(Input::MOUSELEFT)
          @state = !@state
          @block.call(@state) if @block
        end
      end
    else
      @selected = false
      return
    end
  end

  def draw(bitmap)
    case @type
    when :normal
      if @state
        icon_type = :pressed
      else
        icon_type = :unpressed
      end
    when :radio_unpressed, :radio_pressed
      if @state
        icon_type = :radio_pressed
      else
        icon_type = :radio_unpressed
      end
    when :file
      icon_type = :file
    else
      print "Unknown button type: #{@type}"
    end

    icon = $system.button(icon_type)
    opacity = @options[:opacity]
    opacity ||= 255
    bitmap.stretch_blt(@rect, icon, Rect.new(0, 0, icon.width, icon.height), opacity)
  end

  def state
    return @state
  end

  def state=(state)
    @state = state
  end

  def selected?
    return @selected
  end

  def on_click(&block)
    @block = block
    @block.call(@state)
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
