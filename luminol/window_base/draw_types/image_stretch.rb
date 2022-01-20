class StretchedImageInstruction
  def initialize(options = {})
    if options[:file]
      @bitmap = Bitmap.new(options[:file])
    elsif options[:bitmap]
      @image = options[:bitmap]
    end

    @x = options[:x]
    @y = options[:y]

    @rect = options[:src_rect]
    @rect2 = options[:dest_rect]

    @opacity = options[:opacity]
    @opacity ||= 255
  end

  def draw(bitmap)
    bitmap.stretch_blt(@rect2, @bitmap, @rect, @opacity)
  end
end
