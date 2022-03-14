require_relative 'button'

class RadioButton < Button
  def initialize(rect, options = {})
    raise 'No siblings!' if options[:siblings].nil?

    pressed = options[:pressed]
    pressed ||= false
    if pressed
      super(rect, options)
    else
      super(rect, options)
    end
    @state = pressed
    @siblings = options[:siblings]
  end

  def update(window)
    return unless @visible

    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in button

      if @selected && Input.trigger?(Input::MOUSELEFT) && !@state # If not already pressed
        # Unpress siblings
        id = @siblings.index(self)
        @siblings.each do |sibling|
          next if sibling == self

          sibling.state = false
        end

        @state = true # State is always true when clicked
        @block&.call(id)
      end
    else
      @selected = false
    end
  end

  def on_click(&block)
    @block = block
    id = @siblings.index(self)
    @block.call(id) if @state
  end
end
