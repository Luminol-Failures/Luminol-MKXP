require_relative "button"

class RadioButton < Button
  def initialize(rect, options = {})
    raise "No siblings!" if options[:siblings] == nil
    pressed = options[:pressed]
    pressed ||= false
    if pressed
      super(rect, :radio_pressed, options)
    else
      super(rect, :radio_unpressed, options)
    end
    @state = pressed
    @siblings = options[:siblings]
  end

  def update(window)
    if MKXP.mouse_in_window
      x1 = @rect.x
      y1 = @rect.y
      x2 = @rect.x + @rect.width
      y2 = @rect.y + @rect.height

      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) # Check if mouse is in button

      if @selected
        if Input.trigger?(Input::MOUSELEFT)
          unless @state # If not already pressed
            # Unpress siblings
            id = @siblings.index(self)
            @siblings.each do |sibling|
              next if sibling == self
              sibling.state = false
            end

            @state = true # State is always true when clicked
            @block.call(id) if @block
          end
        end
      end
    else
      @selected = false
      return
    end
  end

  def on_click(&block)
    @block = block
    id = @siblings.index(self)
    @block.call(id) if @state
  end
end
