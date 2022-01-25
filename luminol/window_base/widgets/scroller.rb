class Scroller
  def initialize(rect, options = {})
    @rect = rect
    @options = options

    @selected = false
    @ox = 0
    @oy = 0

    @scroll_x = false
    @scroll_y = false

    @scrolling_x = false
    @scrolling_y = false

    @drag_x = 0
    @drag_y = 0
    @drag_ox = 0
    @drag_oy = 0
  end

  def add_widget(widget)
    @widget = widget
    if widget.width > @rect.width
      @scroll_x = true
    end
    if widget.height > @rect.height
      @scroll_y = true
    end

    @contents = Bitmap.new(@widget.width, @widget.height)
  end

  def update(window)
    if MKXP.mouse_in_window
      mx = Input.mouse_x
      my = Input.mouse_y

      @selected = inside?(window, mx, my) # Check if mouse is in button

      @selected = @widget.selected? if @widget

      if @widget
        scroll_x_ratio = @rect.width.to_f / @widget.width
        scroll_x_width = @rect.width * scroll_x_ratio
        scrollbar_x = scroll_x_ratio * @ox

        scroll_y_ratio = @rect.height.to_f / @widget.height
        scroll_y_height = @rect.height * scroll_y_ratio
        scrollbar_y = scroll_y_ratio * @oy
        if @scroll_x && Input.trigger?(Input::MOUSELEFT)
          x1 = @rect.x + scrollbar_x + 16 + window.x
          x2 = x1 + scroll_x_width
          y1 = @rect.y + @rect.height + 16 + window.y
          y2 = y1 + $system.scrollbar_width

          if mx >= x1 && mx <= x2 && my >= y1 && my <= y2
            @scrolling_x = true
            @drag_x = mx
            @drag_ox = @ox
          end
        end
        if @scroll_y && Input.trigger?(Input::MOUSELEFT)
          x1 = @rect.x + @rect.width + 16 + window.x
          x2 = x1 + $system.scrollbar_width
          y1 = @rect.y + scrollbar_y + 16 + window.y
          y2 = y1 + scroll_y_height

          if mx >= x1 && mx <= x2 && my >= y1 && my <= y2
            @scrolling_y = true
            @drag_y = my
            @drag_oy = @oy
          end
        end

        if @scrolling_x && Input.press?(Input::MOUSELEFT)
          @ox = (@drag_ox + (mx - @drag_x)) / scroll_x_ratio
          @ox = @ox.clamp(0, @widget.width - @rect.width)
          window.draw
        else
          @scrolling_x = false
        end

        if @scrolling_y && Input.press?(Input::MOUSELEFT)
          @oy = (@drag_oy + (my - @drag_y)) / scroll_y_ratio
          @oy = @oy.clamp(0, @widget.height - @rect.height)
          window.draw
        else
          @scrolling_y = false
        end
      end
    else
      @selected = @widget.selected? if @widget
      @selected = false if @widget.nil?
    end
    @widget.update(window) if @widget && !@scrolling_x && !@scrolling_y
  end

  def draw(bitmap)
    @contents.clear
    @widget.draw(@contents) if @widget

    # Draw background
    width = @rect.width
    height = @rect.height
    width += $system.scrollbar_width if @scroll_y
    height += $system.scrollbar_width if @scroll_x
    bg_rect = Rect.new(0, 0, width, height)
    bitmap.fill_rect(bg_rect, Color.new(48, 48, 48))

    # Copy the contents of the widget to the scroller
    bitmap.stretch_blt(
      @rect,
      @contents,
      Rect.new(
        @ox,
        @oy,
        @rect.width,
        @rect.height
      )
    )

    # Draw the scrollbar
    if @scroll_x
      scroll_x_ratio = @rect.width.to_f / @widget.width
      scroll_x_width = @rect.width * scroll_x_ratio
      scrollbar_x = scroll_x_ratio * @ox
      bitmap.stretch_blt(
        Rect.new(
          @rect.x + scrollbar_x,
          @rect.y + @rect.height,
          scroll_x_width,
          $system.scrollbar_width
        ),
        $system.scrollbar,
        Rect.new(0, 0, 16, 16)
      )
    end

    if @scroll_y
      scroll_y_ratio = @rect.height.to_f / @widget.height
      scroll_y_height = @rect.height * scroll_y_ratio
      scrollbar_y = scroll_y_ratio * @oy
      bitmap.stretch_blt(
        Rect.new(
          @rect.x + @rect.width,
          @rect.y + scrollbar_y,
          $system.scrollbar_width,
          scroll_y_height
        ),
        $system.scrollbar(true),
        Rect.new(0, 0, 16, 16)
      )
    end
  end

  def selected?
    return @selected
  end

  def width
    width = @rect.width
    width += $system.scrollbar_width if @scroll_y
    return width
  end

  def height
    height = @rect.height
    height += $system.scrollbar_width if @scroll_x
    return height
  end

  def x
    return @rect.x
  end

  def y
    return @rect.y
  end

  def inside?(window, x, y)
    x1 = @rect.x + window.x + 16
    y1 = @rect.y + window.y + 16
    x2 = @rect.x + @rect.width + window.x + 16
    y2 = @rect.y + @rect.height + window.y + 16

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end
end
