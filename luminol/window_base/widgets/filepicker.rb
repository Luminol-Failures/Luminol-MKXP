require_relative "../../system/os"
require_relative 'widget'
class Filepicker < Widget
  attr_accessor :clipped_region, :current_directory, :scroller, :min_width, :min_height
  attr_reader :selected_file, :starting_directory, :index, :current_drive

  def initialize(rect, options = {})
    super(rect, options)

    @index = options[:index]
    @index ||= -1

    @starting_directory = options[:starting_directory]
    @starting_directory ||= $system.working_dir
    @current_directory = @starting_directory
    @ext_filter = options[:ext_filter]
    @ext_filter ||= []

    @clipped_region = nil

    @file_icon = $system.button(:file)
    @directory_icon = $system.button(:directory)

    @padding = options[:padding]
    @padding ||= 2

    @item_height = options[:item_height]
    @item_height ||= 18
    @item_height += @padding

    @min_height = rect.height
    @min_height ||= 256

    @min_width = rect.width
    @min_width ||= 64
    @font ||= Font.new(
      Font.default_name,
      @item_height - 8,
    )

    setup_children
    @selected = false
  end

  def setup_children
    if @drive_picker
      require "win32ole"
      file_system = WIN32OLE.new("Scripting.FileSystemObject")
      drives = file_system.Drives

      children = []
      drives.each do |drive|
        children << drive.Path + "/"
      end
    else
      children = Dir.children(@current_directory)
    end
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
    @children.prepend("..") unless @drive_picker
  end

  def width
    calculate_size.width
  end

  def height
    calculate_size.height
  end

  def update(window)
    return unless super window

    if MKXP.mouse_in_window || @selected
      mx, my = get_mouse_pos(window)

      @selected = mouse_inside_widget?(window) # Check if mouse is in list

      if @selected && Input.trigger?(Input::MOUSELEFT)
        index = (my / @item_height)
        if @index != index
          @index = index
          @on_select.call(@children[index]) if @on_select
          window.draw
        elsif @index == index
          if @children[index].nil?
            # Do nothing
          elsif index == 0 && !@drive_picker
            if @current_directory =~ /^[A-Z]:\/$/ || @drive_picker # If we're on a drive
              @current_directory = ""
              @drive_picker = true
            else
              @current_directory = File.expand_path(@current_directory + "/../")
              @drive_picker = false
            end

            @on_navigate.call(@current_directory) if @on_navigate
            setup_children
            if @scroller
              @scroller.ox = 0
              @scroller.oy = 0
            end
            @index = -1
            window.draw
          elsif File.directory?(File.join(@current_directory, @children[index])) || @drive_picker
            if @drive_picker
              @current_directory = @children[index]
            else
              @current_directory = File.join(@current_directory, @children[index])
            end
            @drive_picker = false
            @on_navigate.call(@current_directory) if @on_navigate
            if @scroller
              @scroller.ox = 0
              @scroller.oy = 0
            end
            setup_children
            @index = -1
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
    return unless super bitmap

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

      if File.directory?(File.join(@current_directory, text)) || @drive_picker
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
    rect.width = b.text_size(@children.max_by(&:length).to_s).width + 20

    if rect.width < @min_width
      rect.width = @min_width
    end
    if rect.height < @min_height
      rect.height = @min_height
    end

    b.dispose

    return rect
  end
end
