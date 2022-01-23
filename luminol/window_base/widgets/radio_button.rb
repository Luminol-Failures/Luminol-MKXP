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
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside_button?(window, mx, my) # Check if mouse is in button

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
