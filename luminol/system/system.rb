require_relative "assets"
require_relative "../subscribers/skin"
require_relative "../subscribers/resize"

class System
  attr_accessor :working_dir
  attr_reader :skin_name
  attr_reader :skin

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
end
