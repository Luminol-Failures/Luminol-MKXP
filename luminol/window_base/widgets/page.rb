require_relative "widget"

class Page < Widget
  attr_accessor :clipped_region

  def initialize(rect, options = {})
    super(rect, options)

    @widgets = []
    @pages = []
    @index = 0

    @refbitmap = Bitmap.new(1, 1)
    font = Font.new
    font.size = 12
    @refbitmap.font = font
  end

  def update(window)
    return unless super window

    refresh_widgets window
    if MKXP.mouse_in_window
      mx, my = get_mouse_pos(window)

      @selected = mouse_inside_widget?(window)

      if @selected && Input.trigger?(Input::MOUSELEFT)
        last_x = 0
        @pages.each do |page|
          text_width = @refbitmap.text_size(page).width
          boxes_needed = if text_width < 32
              2
            else
              (text_width / 16.0).ceil
            end

          x1 = last_x
          x2 = x1 + boxes_needed * 16
          y1 = y
          y2 = y1 + 16

          if mx >= x1 && mx <= x2 && my >= y1 && my <= y2
            @index = @pages.index(page)
            window.draw
            break
          end

          last_x += boxes_needed * 16
        end
      end
    end
  end

  def refresh_widgets(window = nil)
    @widgets.each_with_index do |widget, index|
      widget.visible = index == @index
      next if window.nil?
      widget.update(window)
    end
  end

  def draw(bitmap)
    return unless super(bitmap)

    refresh_widgets
    contents = Bitmap.new(width, height - 16)
    topbar = Bitmap.new(width, 32)

    construct_topbar(topbar)
    bitmap.fill_rect(x, y, width, height, Color.new(28, 28, 28))
    @widgets[@index]&.draw(contents)

    bitmap.blt(x, y + 16, contents, @rect)
    bitmap.blt(x, y, topbar, @rect)
  end

  def construct_topbar(bitmap)
    pageleft = $system.button(:pageleft)
    pagemiddle = $system.button(:pagemiddle)
    pageright = $system.button(:pageright)

    bitmap.font = @refbitmap.font

    last_x = 0
    rect16 = Rect.new(0, 0, 16, 16)

    @pages.each_with_index do |page, index|
      text_width = bitmap.text_size(page).width

      boxes_needed = if text_width < 32
          2
        else
          (text_width / 16.0).ceil
        end

      bitmap.blt(last_x, y, pageleft, rect16)
      (boxes_needed - 2).times do |i|
        bitmap.blt(
          x + 16 + (i * 16) + last_x,
          y,
          pagemiddle,
          rect16
        )
      end
      bitmap.blt(last_x + (boxes_needed * 16) - 16, y, pageright, rect16)

      bitmap.font.color = if @index == index
          Color.new(255, 255, 255)
        else
          Color.new(128, 128, 128)
        end

      bitmap.draw_text(
        x + last_x + 4,
        y,
        text_width,
        16,
        page
      )

      last_x += boxes_needed * 16
    end
  end

  def add_widget(widget, page)
    widget.clipped_region = @rect if widget.respond_to?(:clipped_region) # Check if widget has a clipped_region method
    widget.oy = -16 - y
    widget.visible = false

    @widgets << widget
    @pages << page
  end

  def on_change(&block)
    @on_change = block
  end
end
