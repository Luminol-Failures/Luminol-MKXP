require_relative "../window_base/window_draggable"
require_relative "../window_base/widgets/filepicker"
require_relative "../window_base/widgets/scroller"
require_relative '../subscribers/project'

class Window_ProjectPicker < Window_Draggable
  attr_reader :finished

  def initialize
    icon = $system.button(:file)
    super(0, 0, 240, 320, "Open Project", icon)

    @finished = false

    @picker = Filepicker.new(
      Rect.new(0, 0, self.width - 32 - $system.scrollbar_width, self.height),
      ext_filter: [".rxproj", ".lum", ".lumino", ".luminolproj"],
    )

    @picker.on_finish do |path, _|
      @finished = true
      $system.working_dir = path
      self.close
      $projectsignal.notify(path)
    end

    @scroller = Scroller.new(
      Rect.new(0, 0, self.width - 32 - $system.scrollbar_width, self.height - 32),
    )
    @scroller.add_widget(@picker)

    self.add_widget(:scroller, @scroller)
    self.close
  end

  def open
    super
    @finished = false
  end
end
