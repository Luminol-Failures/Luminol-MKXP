require_relative 'widget'
class Scroller < Widget
  def initialize(rect, options = {})
    super(rect, options)

    @selected = false
    @widget_ox = 0.0
    @widget_oy = 0.0

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

    if widget.respond_to?(:clipped_region) # Check if widget has a clipped_region method
      widget.clipped_region = @rect
    end
    if widget.respond_to?(:scroller)
      widget.scroller = self
    end

    setup_contents
  end

  def refresh_contents
    if @widget.width > @rect.width
      @scroll_x = true
    end
    if @widget.height > @rect.height
      @scroll_y = true
    end
  end

  def setup_contents
    @contents = Bitmap.new(
      @widget.width,
      @widget.height
    )
    @widget_ox = 0
    @widget_oy = 0
    refresh_contents

    @draw_on_next_update = true
  end

  def update(window)
    return unless super window

    if @widget.width != @contents.width || @widget.height != @contents.height
      @contents.dispose
      setup_contents
    end

    if @widget
      @widget.update(window)
      @widget.ox = @widget_ox + self.ox - x
      @widget.oy = @widget_oy + self.oy - y

    end
    if MKXP.mouse_in_window
      mx, my = get_mouse_pos(window)

      @selected = mouse_inside_widget?(window)

      @selected = @widget.selected? if @widget && !@selected

      if @selected && @widget
        if Input.mouse_scroll && !@scrolling_x && !@scrolling_y
          if @scroll_x && Input.mouse_scroll_x != 0
            @widget_ox = (@widget_ox + Input.mouse_scroll_x * $system.scroll_speed_multiplier).clamp(0, @widget.width - @rect.width)
          end

          if @scroll_y && Input.mouse_scroll_y != 0
            @widget_oy = (@widget_oy - Input.mouse_scroll_y * $system.scroll_speed_multiplier).clamp(0, @widget.height - @rect.height)
          end
          window.draw
        end
      end

      if @widget && @selected
        scroll_x_ratio = width.to_f / @widget.width
        scroll_x_width = width * scroll_x_ratio
        scrollbar_x = scroll_x_ratio * @widget_ox

        scroll_y_ratio = height.to_f / @widget.height
        scroll_y_height = height * scroll_y_ratio
        scrollbar_y = scroll_y_ratio * @widget_oy
        if @scroll_x && Input.trigger?(Input::MOUSELEFT)
          x1 = scrollbar_x
          x2 = x1 + scroll_x_width
          y1 = height - $scrollbar_width
          y2 = height

          if mx >= x1 && mx <= x2 && my >= y1 && my <= y2
            @scrolling_x = true
            @drag_x = mx
            @drag_ox = @widget_ox
          end
        end
        if @scroll_y && Input.trigger?(Input::MOUSELEFT)
          x1 = width - $system.scrollbar_width
          x2 = width
          y1 = scrollbar_y
          y2 = y1 + scroll_y_height

          if mx >= x1 && mx <= x2 && my >= y1 && my <= y2
            @scrolling_y = true
            @drag_y = my
            @drag_oy = @widget_oy
          end
        end

        if @scrolling_x && Input.press?(Input::MOUSELEFT)
          @widget_ox = (@drag_ox + (mx - @drag_x)) / scroll_x_ratio
          @widget_ox = @widget_ox.clamp(0, @widget.width - width)
          window.draw
        else
          @scrolling_x = false
        end

        if @scrolling_y && Input.press?(Input::MOUSELEFT)
          @widget_oy = (@drag_oy + (my - @drag_y)) / scroll_y_ratio
          @widget_oy = @widget_oy.clamp(0, @widget.height - height)
          window.draw
        else
          @scrolling_y = false
        end
      end
    else
      @selected = @widget.selected? if @widget
      @selected = false if @widget.nil?
    end
  end

  def draw(bitmap)
    return unless super bitmap
    return unless @widget

    @contents.clear

    # Note to self: some people have shit graphics cards.
    # this may exceed the maximum texture size.
    # TODO: find a way to fix this.
    @widget.draw(@contents) if @widget

    # Draw background
    bg_rect = Rect.new(x, y, self.width, self.height)
    bitmap.fill_rect(bg_rect, Color.new(48, 48, 48))

    # Copy the contents of the widget to the scroller
    bitmap.stretch_blt(
      @rect,
      @contents,
      Rect.new(
        @widget_ox,
        @widget_oy,
        @rect.width,
        @rect.height
      )
    )

    # Draw the scrollbar
    if @scroll_x
      scroll_x_ratio = self.width.to_f / @widget.width
      scroll_x_width = self.width * scroll_x_ratio
      scrollbar_x = scroll_x_ratio * @widget_ox
      bitmap.stretch_blt(
        Rect.new(
          x + scrollbar_x,
          y + @rect.height,
          scroll_x_width,
          $system.scrollbar_width
        ),
        $system.scrollbar,
        Rect.new(0, 0, 16, 16)
      )
    end

    if @scroll_y
      scroll_y_ratio = self.height.to_f / @widget.height
      scroll_y_height = self .height * scroll_y_ratio
      scrollbar_y = scroll_y_ratio * @widget_oy
      bitmap.stretch_blt(
        Rect.new(
          x + @rect.width,
          y + scrollbar_y,
          $system.scrollbar_width,
          scroll_y_height
        ),
        $system.scrollbar(true),
        Rect.new(0, 0, 16, 16)
      )
    end
  end

  def width
    width = @rect.width
    width += $system.scrollbar_width if @scroll_y
    width
  end

  def height
    height = @rect.height
    height += $system.scrollbar_width if @scroll_x
    height
  end
end
