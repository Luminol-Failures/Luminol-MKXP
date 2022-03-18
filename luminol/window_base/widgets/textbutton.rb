require_relative 'button'

class TextButton < Button
  def initialize(rect, options = nil)
    super rect, options
    @text = options[:text] || ""
    @font = options[:font] || Font.new
    @text_color = options[:text_color] || Color.new(255, 255, 255)
    @font.size = 12
    @font.color = @text_color
  end

  def draw(bitmap)
    return unless widget_origin_draw bitmap

    bfont = bitmap.font
    bitmap.font = @font
    text_width = bitmap.text_size(@text).width

    rect16 =  Rect.new(0, 0, 16, 16)
    boxes_needed = if text_width < 32
                     2
                   else
                     (text_width / 16.0).ceil
                   end

    left = $system.button(:pageleft)
    middle = $system.button(:pagemiddle)
    right = $system.button(:pageright)

    bitmap.blt(x, y, left, rect16)
    (boxes_needed - 2).times do |i|
      bitmap.blt(
        x + 16 + (i * 16),
        y,
        middle,
        rect16
      )
    end
    bitmap.blt(x + (boxes_needed * 16) - 16, y, right, rect16)

    bitmap.draw_text(
      x + 4,
      y,
      text_width,
      16,
      @text,
    )

    bitmap.font = bfont
  end
end
