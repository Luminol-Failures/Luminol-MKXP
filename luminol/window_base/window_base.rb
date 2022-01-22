require_relative "../subscribers/skin"
require_relative "../subscribers/resize"
require_relative "draw_instructions"

class Window_Base < Window
  def initialize(x, y, width, height)
    super()
    self.windowskin = $system.windowskin
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    @draw_instructions = DrawInstructions.new

    SkinSignal.on_call do |skin|
      self.windowskin = $system.windowskin
    end
  end

  def on_resize(&block)
    if defined?(@id)
      # Remove the old subscriber
      ResizeSignal >> @id
      @id = ResizeSignal << block
    else
      @id = ResizeSignal << block
    end
  end

  def draw
    # Return if the bitmap is not set
    return if self.contents.nil?
    self.contents.clear
    @draw_instructions.draw(self.contents)
  end

  def on_draw(type, id, options = {})
    @draw_instructions.add(type, id, options)
  end

  def update
    super
  end

  def self.text_color(n)
    case n
    when 0
      return Color.new(255, 255, 255, 255)
    when 1
      return Color.new(255, 64, 64, 255)
    when 2
      return Color.new(0, 224, 0, 255)
    when 3
      return Color.new(255, 255, 0, 255)
    when 4
      return Color.new(64, 64, 255, 255)
    when 5
      return Color.new(255, 64, 255, 255)
    when 6
      return Color.new(64, 255, 255, 255)
    when 7
      return Color.new(128, 128, 128, 255)
    else
      normal_color
    end
  end

  def dispose
    # Dispose if window contents bit map is set
    unless self.contents.nil?
      self.contents.dispose
    end
    super
  end

  def normal_color
    return Color.new(255, 255, 255, 255)
  end

  def active_item_color
    return Color.new(222, 134, 0, 255)
  end

  def disabled_color
    return Color.new(255, 255, 255, 128)
  end

  def system_color
    return Color.new(192, 224, 255, 255)
  end

  def crisis_color
    return Color.new(255, 255, 64, 255)
  end

  def knockout_color
    return Color.new(255, 64, 0)
  end
end
