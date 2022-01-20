class FontInstruction
  def initialize(options = {})
    size = options[:size]
    size ||= Font.default_size
    name = options[:name]
    name ||= Font.default_name
    @font = Font.new(name, size)
    @font.color = options[:color] if options[:color]
    @font.bold = options[:bold] if options[:bold]
    @font.color = options[:color] if options[:color]
  end

  def draw(bitmap)
    bitmap.font = @font
  end
end
