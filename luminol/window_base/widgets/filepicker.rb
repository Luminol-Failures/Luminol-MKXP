require_relative "../../system/os"

# Windows class definition
# We pretty much need to have two different class definitions because of how different the linux and windows filesystems can be
# Windows will need a drive picker, same with linux, but how we get that depends on the OS
# For now, I'm not going to add drive picker support, but I'll add it later

# TODO: Add drive picker support
# TODO: Add support for linux
if OS.os == "windows"
  class Filepicker
    attr_accessor :ox, :oy
    attr_accessor :clipped_region

    attr_accessor :current_directory
    attr_reader :selected_file
    attr_reader :starting_directory
    attr_reader :index

    attr_reader :current_drive # Needed for when I add drive picker support, that will be a different widget

    attr_accessor :scroller

    def initialize(rect, options = {})
      @x, @y = rect.x, rect.y

      @index = options[:index]
      @index ||= 0

      @starting_directory = options[:starting_directory]
      @starting_directory ||= $system.working_dir
      @current_directory = @starting_directory
      @ext_filter = options[:ext_filter]
      @ext_filter ||= []

      @ox = @oy = 0
      @clipped_region = nil

      @file_icon = $system.button(:file)
      @directory_icon = $system.button(:directory)

      @padding = options[:padding]
      @padding ||= 2

      @item_height = options[:item_height]
      @item_height ||= 18
      @item_height += @padding

      @min_height = options[:min_height]
      @min_height ||= 256

      @min_width = options[:min_width]
      @min_width ||= 64
      @font ||= Font.new(
        Font.default_name,
        @item_height - 8,
      )

      setup_children
      @selected = false
    end

    def setup_children
      children = Dir.children(@current_directory)
      folders = []
      files = []
      children.each do |child|
        if File.directory?(File.join(@current_directory, child))
          folders << child
          next
        end
        ext = File.extname(child)
        if @ext_filter.empty?
          files << child
        else
          files << child if @ext_filter.include?(ext)
        end
      end
      files.sort! { |a, b| a <=> b }
      folders.sort! { |a, b| a <=> b }
      @children = folders + files
      @children.prepend("..")
    end

    def selected?
      return @selected
    end

    def x
      @x
    end

    def y
      @y
    end

    def width
      calculate_size.width
    end

    def height
      calculate_size.height
    end

    def update(window)
      if MKXP.mouse_in_window || @selected
        mx = Input.mouse_x
        my = Input.mouse_y

        @selected = inside?(window, mx, my) # Check if mouse is in list

        if @selected && Input.trigger?(Input::MOUSELEFT)
          index = ((my - self.y - window.y - 16 + @oy) / @item_height)
          if @index != index
            @index = index
            @on_select.call(@children[index]) if @on_select
            window.draw
          elsif @index == index
            if @children[index].nil?
              # Do nothing
            elsif index == 0
              @current_directory = File.expand_path(@current_directory + "../")
              @on_navigate.call(@current_directory) if @on_navigate
              setup_children
              if @scroller
                @scroller.ox = 0
                @scroller.oy = 0
              end
              window.draw
            elsif File.directory?(File.join(@current_directory, @children[index]))
              @current_directory = File.join(@current_directory, @children[index])
              @on_navigate.call(@current_directory) if @on_navigate
              if @scroller
                @scroller.ox = 0
                @scroller.oy = 0
              end
              setup_children
              window.draw
            else
              @selected_file = File.join(@current_directory, @children[index])
              @on_finish.call(@selected_file) if @on_finish
            end
          end
        end
      else
        @selected = false
        return
      end
    end

    def draw(bitmap)
      width = self.width
      bfont = bitmap.font
      bitmap.font = @font
      (self.height / @item_height.to_f).round.times do |i|
        rect = Rect.new(0, @item_height * i, width, @item_height)
        color = Color.new(0, 0, 0) if i.even?
        color = Color.new(40, 40, 40) if i.odd?
        color = Color.new(color.red + 80, color.green, color.blue + 100) if @index == i

        bitmap.fill_rect(rect, color)

        text = @children[i]
        next if text.nil?
        if File.directory?(File.join(@current_directory, text))
          bitmap.blt(rect.x + 4, rect.y + 4, @directory_icon, Rect.new(0, 0, 16, 16))
        else
          bitmap.blt(rect.x + 4, rect.y + 4, @file_icon, Rect.new(0, 0, 16, 16))
        end

        rect.x = 20
        bitmap.draw_text(rect, text) if text

        rect.x = 0
        rect.height = @padding
        rect.y = @item_height * (i + 1) - @padding
        border_color = Color.new(128, 128, 128)
        bitmap.fill_rect(rect, border_color)
      end
      bitmap.font = bfont
    end

    def on_finish(&block)
      @on_finish = block
    end

    def on_select(&block)
      @on_select = block
    end

    def on_navigate(&block)
      @on_navigate = block
    end

    def calculate_size
      rect = Rect.new(@x, @y, 0, 0)
      # Temporary bitmap for text size calculation
      b = Bitmap.new(1, 1)
      b.font = @font

      rect.height = @children.size * @item_height
      rect.width = b.text_size(@children.max_by(&:length)).width + 20

      if rect.width < @min_width
        rect.width = @min_width
      end
      if rect.height < @min_height
        rect.height = @min_height
      end

      b.dispose

      return rect
    end

    def inside?(window, x, y)
      if @clipped_region
        x1 = @clipped_region.x + window.x + 16
        y1 = @clipped_region.y + window.y + 16
        x2 = x1 + @clipped_region.width
        y2 = y1 + @clipped_region.height
      else
        x1 = self.x + window.x + 16
        y1 = self.y + window.y + 16
        x2 = x1 + self.width
        y2 = y1 + self.height
      end

      return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
    end
  end
else
  class Filepicker
    attr_accessor :ox, :oy
    attr_accessor :clipped_region

    attr_accessor :current_directory
    attr_reader :selected_file
    attr_reader :starting_directory
    attr_reader :index

    attr_reader :current_drive # Needed for when I add drive picker support, that will be a different widget

    attr_accessor :scroller

    def initialize(rect, options = {})
      @x, @y = rect.x, rect.y

      @index = options[:index]
      @index ||= 0

      @starting_directory = options[:starting_directory]
      @starting_directory ||= $system.working_dir
      @current_directory = @starting_directory
      @ext_filter = options[:ext_filter]
      @ext_filter ||= []

      @ox = @oy = 0
      @clipped_region = nil

      @file_icon = $system.button(:file)
      @directory_icon = $system.button(:directory)

      @padding = options[:padding]
      @padding ||= 2

      @item_height = options[:item_height]
      @item_height ||= 18
      @item_height += @padding

      @min_height = options[:min_height]
      @min_height ||= 256

      @min_width = options[:min_width]
      @min_width ||= 64
      @font ||= Font.new(
        Font.default_name,
        @item_height - 8,
      )

      setup_children
      @selected = false
    end

    def setup_children
      children = Dir.children(@current_directory)
      folders = []
      files = []
      children.each do |child|
        if File.directory?(File.join(@current_directory, child))
          folders << child
          next
        end
        ext = File.extname(child)
        if @ext_filter.empty?
          files << child
        else
          files << child if @ext_filter.include?(ext)
        end
      end
      files.sort! { |a, b| a <=> b }
      folders.sort! { |a, b| a <=> b }
      @children = folders + files
      @children.prepend("..")
    end

    def selected?
      return @selected
    end

    def x
      @x
    end

    def y
      @y
    end

    def width
      calculate_size.width
    end

    def height
      calculate_size.height
    end

    def update(window)
      if MKXP.mouse_in_window
        mx = Input.mouse_x
        my = Input.mouse_y

        @selected = inside?(window, mx, my) # Check if mouse is in list

        if @selected && Input.trigger?(Input::MOUSELEFT)
          index = ((my - self.y - window.y - 16 + @oy) / @item_height)
          if @index != index
            @index = index
            @on_select.call(@children[index]) if @on_select
            window.draw
          elsif @index == index
            if @children[index].nil?
              # Do nothing
            elsif index == 0
              @current_directory = File.dirname(@current_directory + "../")
              @on_navigate.call(@current_directory) if @on_navigate
              setup_children
              if @scroller
                @scroller.ox = 0
                @scroller.oy = 0
              end
              window.draw
            elsif File.directory?(File.join(@current_directory, @children[index]))
              @current_directory = File.join(@current_directory, @children[index])
              @on_navigate.call(@current_directory) if @on_navigate
              if @scroller
                @scroller.ox = 0
                @scroller.oy = 0
              end
              setup_children
              window.draw
            else
              @selected_file = File.join(@current_directory, @children[index])
              @on_finish.call(@selected_file) if @on_finish
            end
          end
        end
      else
        @selected = false
        return
      end
    end

    def draw(bitmap)
      width = self.width
      bfont = bitmap.font
      bitmap.font = @font
      (self.height / @item_height.to_f).round.times do |i|
        rect = Rect.new(0, @item_height * i, width, @item_height)
        color = Color.new(0, 0, 0) if i.even?
        color = Color.new(40, 40, 40) if i.odd?
        color = Color.new(color.red + 80, color.green, color.blue + 100) if @index == i

        border_color = Color.new(128, 128, 128)
        bitmap.fill_rect(rect, border_color)
        bitmap.fill_rect(rect, color)

        text = @children[i]
        next if text.nil?
        if File.directory?(File.join(@current_directory, text))
          bitmap.blt(rect.x + 4, rect.y + 4, @directory_icon, Rect.new(0, 0, 16, 16))
        else
          bitmap.blt(rect.x + 4, rect.y + 4, @file_icon, Rect.new(0, 0, 16, 16))
        end

        rect.x = 20
        bitmap.draw_text(rect, text) if text

        rect.x = 0
        rect.height = @padding
        rect.y = @item_height * (i + 1) - @padding
      end
      bitmap.font = bfont
    end

    def on_finish(&block)
      @on_finish = block
    end

    def on_select(&block)
      @on_select = block
    end

    def on_navigate(&block)
      @on_navigate = block
    end

    def calculate_size
      rect = Rect.new(@x, @y, 0, 0)
      # Temporary bitmap for text size calculation
      b = Bitmap.new(1, 1)
      b.font = @font

      rect.height = @children.size * @item_height
      rect.width = b.text_size(@children.max_by(&:length)).width + 20

      if rect.width < @min_width
        rect.width = @min_width
      end
      if rect.height < @min_height
        rect.height = @min_height
      end

      b.dispose

      return rect
    end

    def inside?(window, x, y)
      if @clipped_region
        x1 = @clipped_region.x + window.x + 16
        y1 = @clipped_region.y + window.y + 16
        x2 = x1 + @clipped_region.width
        y2 = y1 + @clipped_region.height
      else
        x1 = self.x + window.x + 16
        y1 = self.y + window.y + 16
        x2 = x1 + self.width
        y2 = y1 + self.height
      end

      return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
    end
  end
end
