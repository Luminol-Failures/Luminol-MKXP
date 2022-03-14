require_relative "assets"
require_relative "../subscribers/skin"
require_relative "../subscribers/resize"

class System
  attr_accessor :working_dir
  attr_reader :skin_name
  attr_reader :skin

  attr_accessor :border_color
  attr_accessor :interior_color
  attr_accessor :scrollbar_width

  attr_reader :max_texture_size

  attr_accessor :scroll_speed_multiplier

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
    up: 9,
    down: 10,

    note: 12,
    bar: 13,
    bar_vertical: 14,

    slider: 16,
    slider_vertical: 17,
    rgb_top: 18,
    rgb_bottom: 19,

    directory: 20,
    pageleft: 21,
    pagemiddle: 22,
    pageright: 23,
  }.freeze

  CURSOR_TYPES = {
    upright: 0,
    up: 1,
    upleft: 2,
    question: 3,
    #
    left: 4,
    normal: 5,
    right: 6,
    stop: 7,
    #
    downleft: 8,
    down: 9,
    downright: 10,
    no: 11,
    #
    text: 12,
    hand: 13,
    tile: 14,
    yes: 15
  }.freeze

  def initialize
    @working_dir = Dir.pwd
    @skin_name = "default"
    @cursor_skin_name = "default"
    @cursor_skin = Assets.cursor_skin(@cursor_skin_name)
    @skin = Assets.skin(@skin_name)

    @border_color = Color.new(168, 178, 255)
    @interior_color = Color.new(255, 255, 255)
    @scrollbar_width = 8

    @max_texture_size = 4096 # NEVER EXCEED 4096
    @scroll_speed_multiplier = 20
  end

  def skin_name=(name)
    @skin_name = name
    @skin = Assets.skin(@skin_name)
    $skinsignal.notify_change(@skin)
  end

  def update
    $resizesignal.update
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

  def cursor(id)
    Assets.cursor(@cursor_skin_name, CURSOR_TYPES[id])
  end

  def scrollbar(vertical = false)
    if vertical
      button(:bar_vertical)
    else
      button(:bar)
    end
  end

  def slider(vertical = false)
    if vertical
      button(:slider_vertical)
    else
      button(:slider)
    end
  end
end
