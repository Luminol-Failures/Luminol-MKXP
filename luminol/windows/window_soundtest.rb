require_relative '../window_base/window_draggable'
require_relative '../window_base/widgets/plane'
require_relative '../window_base/widgets/page'
require_relative '../window_base/widgets/list'
require_relative '../window_base/widgets/scroller'
require_relative '../window_base/widgets/slider'
require_relative '../window_base/widgets/textbutton'

require_relative '../subscribers/project'

class Window_SoundTest < Window_Draggable
  def initialize
    super(0, 0, 270, 330, 'Sound Test', $system.button(:note))
    self.close

    @volume = 100
    @pitch = 100

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

    @page = Page.new(Rect.new(0, 0, width - 32, height - 32))

    %w[bgm bgs se me].each do |entity|
      e = <<~CHANNELSTRING
        @#{entity} = ""
        @#{entity}_plane = PlaneWidget.new(Rect.new(0, 0, width - 32, height - 64))
        @page.add_widget(@#{entity}_plane, "#{entity.upcase}")
        @#{entity}_list = List.new(Rect.new(0, 0, 128, 256), items: [])
        @#{entity}_scroller = Scroller.new(Rect.new(16, 16, 128, 256))
        @#{entity}_scroller.add_widget(@#{entity}_list)
        @#{entity}_plane.add_widget(:scroller, @#{entity}_scroller)
        @#{entity}_plane.add_widget(:volume, @volume_slider)
        @#{entity}_plane.add_widget(:pitch, @pitch_slider)

        @#{entity}_list.on_select do |item, _|
          print "FILE MISSING!" unless File.exist?($system.working_dir + "/Audio/#{entity.upcase}/" + item)
          @#{entity} = item
          draw
        end

        @#{entity}_play_button = TextButton.new(Rect.new(198, 16, 128, 32),
                                  text: 'Play')
        @#{entity}_stop_button = TextButton.new(Rect.new(198, 46, 128, 32),
                                  text: 'Stop')

        @#{entity}_play_button.on_click do
          next if @#{entity}.nil? || @#{entity}.empty?
          Audio.#{entity}_play("Audio/#{entity.upcase}/" + @#{entity}, @volume, @pitch)
        end

        @#{entity}_stop_button.on_click do
          Audio.#{entity}_stop
          @#{entity} = ""
        end

        @#{entity}_plane.add_widget(:play, @#{entity}_play_button)
        @#{entity}_plane.add_widget(:stop, @#{entity}_stop_button)
      CHANNELSTRING
      eval(e)
    end

    add_widget(:page, @page)

    $projectsignal.on_call do |path|
      %w[bgm bgs se me].each do |entity|
        begin
          eval("@#{entity}_list.items = Dir.children(path + \"/Audio/#{entity.upcase}/\")")
        rescue
          eval("@#{entity}_list.items = []")
          print "Audio/#{entity.upcase}/ missing!"
        end
      end
      draw
    end
  end

  def open
    super
    self.x = Input.mouse_x
    self.y = Input.mouse_y + 32
  end
end