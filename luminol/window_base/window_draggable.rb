require_relative "window_selectable"

class Window_Draggable < Window_Selectable
  def initialize(x, y, width, height, title = "", icon = Bitmap.new(16, 16))
    super(x, y + 32, width, height)
    # We offset the window by 32 pixels to make room for the title bar
    @title = title
    @icon = icon

    @dragging = false
    @drag_x = 0
    @drag_y = 0

    @titlebar = Sprite.new
    @minimized = false
    @closed = false
  end

  def update
    return if @closed

    super()
    @titlebar.update

    self.visible = !@minimized

    return unless MKXP.mouse_in_window
    x1 = self.x
    y1 = self.y - 32
    x2 = self.x + self.width
    y2 = self.y + 32
    # Check if mouse is in window

    mx = Input.mouse_x
    my = Input.mouse_y

    if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) || @dragging
      x1 = self.x + self.width - 64 - 8
      # Check if mouse is in titlebar buttons

      if Input.trigger?(Input::MOUSELEFT)
        @dragging = true
        @drag_x = mx - self.x
        @drag_y = my - self.y
        self.z += 1 # Bring window up a layer
        @titlebar.z = self.z
      end

      if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2)
        @dragging = false

        # Check if mouse is in close button
        x1 = self.x + self.width - 32 - 4
        if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2)
          if Input.trigger?(Input::MOUSELEFT)
            @closed = true
            self.visible = false
            @titlebar.visible = false
          end
        end

        x1 = self.x + self.width - 48 - 8
        # Check if mouse is in minimize button
        if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2)
          if Input.trigger?(Input::MOUSELEFT)
            @minimized = !@minimized
            draw_titlebar
          end
        end

        return
      end

      if Input.press?(Input::MOUSELEFT)
        self.x = mx - @drag_x
        self.y = my - @drag_y

        #self.ox = self.x
        #self.oy = self.y - 32

        @titlebar.x = self.x
        @titlebar.y = self.y - 32
      else
        @dragging = false
      end
    end
  end

  def draw
    return if @closed
    super()
    draw_titlebar
  end

  def draw_titlebar
    bitmap = Bitmap.new(self.width, 32)
    title_pieces = []
    8.times do |i|
      title_pieces << $system.titlebar_element(i)
    end
    2.times do |i|
      srcrect = Rect.new(0, 0, 16, 16)
      bitmap.blt(0, i * 16, title_pieces[0 + (i * 4)], srcrect)
      bitmap.stretch_blt(
        Rect.new(16, i * 16, self.width / 2 - 16, 16),
        title_pieces[1 + (i * 4)],
        srcrect
      )
      bitmap.stretch_blt(
        Rect.new(self.width / 2, i * 16, self.width / 2 - 16, 16),
        title_pieces[2 + (i * 4)],
        srcrect
      )
      bitmap.blt(self.width - 16, i * 16, title_pieces[3 + (i * 4)], srcrect)

      bitmap.blt(8, 8, @icon, Rect.new(0, 0, 16, 16))
      bitmap.font = Font.new("Terminus (TTF)", 16)

      size = bitmap.text_size(@title)
      bitmap.draw_text(
        Rect.new(32, 8, size.width, size.height),
        @title
      )

      close = $system.button(:close)
      bitmap.blt(self.width - 32 - 4, 8, close, Rect.new(0, 0, 16, 16))
      # Change button depending on minimized state
      if @minimized
        store_button = $system.button(:maximize)
      else
        store_button = $system.button(:minimize)
      end
      bitmap.blt(self.width - 48 - 8, 8, store_button, Rect.new(0, 0, 16, 16))
    end

    @titlebar.bitmap = bitmap
  end
end
