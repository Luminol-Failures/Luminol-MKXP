require_relative '../window_base/window_draggable'
require_relative '../window_base/widgets/plane'
require_relative '../window_base/widgets/page'
require_relative '../window_base/widgets/list'
require_relative '../window_base/widgets/scroller'
require_relative '../window_base/widgets/slider'
require_relative '../window_base/widgets/button'

require_relative '../subscribers/project'

class Window_SoundTest < Window_Draggable
  def initialize
    super(0, 0, 270, 470, 'Sound Test', $system.button(:note))
    #self.close

    @bgm = ""
    @se = ""
    @bgs = ""
    @me = ""

    @volume = 100

    @bgm_plane = PlaneWidget.new(Rect.new(0, 0, width - 32, height - 64))
    @bgs_plane = PlaneWidget.new(Rect.new(0, 0, width - 32, height - 64))
    @me_plane = PlaneWidget.new(Rect.new(0, 0, width - 32, height - 64))
    @se_plane = PlaneWidget.new(Rect.new(0, 0, width - 32, height - 64))

    @page = Page.new(Rect.new(0, 0, width - 32, height - 32))
    @page.add_widget(@bgm_plane, "BGM")
    @page.add_widget(@bgs_plane, "BGS")
    @page.add_widget(@me_plane, "ME")
    @page.add_widget(@se_plane, "SE")

    @bgm_list = List.new(Rect.new(0, 0, 128, 256), items: [])
    @bgm_scroller = Scroller.new(Rect.new(16, 16, 128, 256))
    @bgm_scroller.add_widget(@bgm_list)
    @bgm_plane.add_widget(:scroller, @bgm_scroller)

    add_widget(:page, @page)

    @volume_slider = Slider.new(Rect.new(156, 16, 32, 128),
                                min: 0, max: 100, value: 100)

    @volume_slider.on_change do |value|
      @volume = value
    end

    @pitch_slider = Slider.new(Rect.new(156, 148, 32, 128),
                               min: 50, max: 150, value: 100)

    @pitch_slider.on_change do |value|
      @pitch = value
    end

    @bgm_plane.add_widget(:volume, @volume_slider)
    @bgm_plane.add_widget(:pitch, @pitch_slider)

    $projectsignal.on_call do |path|
      begin 
        @bgm_list.items = Dir.children(path + "/Audio/BGM/")
      rescue 
        @bgm_list.items = []
        print "Audio/BGM/ missing!"
      end
      draw
    end

    @bgm_list.on_select do |item, _|
      print "FILE MISSING!" unless File.exist?($system.working_dir + "/Audio/BGM/" + item)
      @bgm = item
      draw
    end
  end

  def open
    super
    self.x = Input.mouse_x
    self.y = Input.mouse_y + 32
  end
end