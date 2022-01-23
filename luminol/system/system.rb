require_relative "assets"
require_relative "../subscribers/skin"
require_relative "../subscribers/resize"

class System
  attr_accessor :working_dir
  attr_reader :skin_name
  attr_reader :skin

  BUTTON_TYPES = {
    close: 0,
    minimize: 1,
    maximize: 2,
    restore: 3,
    unpressed: 4,
    radio_unpressed: 4,
    radio_pressed: 5,
    pressed: 6,
    file: 8,
  }

  def initialize
    @working_dir = ""
    @skin_name = "default"
    @skin = Assets.skin(@skin_name)
  end

  def skin_name=(name)
    @skin_name = name
    @skin = Assets.skin(@skin_name)
    SkinSignal.notify_change(@skin)
  end

  def update
    ResizeSignal.update
  end

  def windowskin
    Assets.skin(@skin_name)
  end

  def titlebar_element(index)
    Assets.titlebar_element(@skin_name, index)
  end

  def button(type)
    Assets.button(@skin_name, BUTTON_TYPES[type])
  end
end
