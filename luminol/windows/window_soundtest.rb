require_relative '../window_base/window_draggable'
require_relative '../window_base/widgets/plane'
require_relative '../window_base/widgets/page'
require_relative '../window_base/widgets/list'
require_relative '../window_base/widgets/scroller'

require_relative '../subscribers/project'

class Window_SoundTest < Window_Draggable
  def initialize
    super(0, 0, 270, 470, 'Sound Test', $system.button(:note))
    #self.close

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

    $projectsignal.on_call do |path|
      @bgm_list.items = Dir.children(path + "/Audio/BGM/")
      draw
    end
  end

  def open
    super
    self.x = Input.mouse_x
    self.y = Input.mouse_y + 32
  end
end