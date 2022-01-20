class ImageInstruction
  def initialize(options = {})
    if options[:file]
      @bitmap = Bitmap.new(options[:file])
    elsif options[:bitmap]
      @image = options[:bitmap]
    end

    @x = options[:x]
    @y = options[:y]

    @rect = options[:src_rect]

    @opacity = options[:opacity]
    @opacity ||= 255
  end

  def draw(bitmap)
    bitmap.blt(@x, @y, @bitmap, @rect, @opacity)
  end
end
