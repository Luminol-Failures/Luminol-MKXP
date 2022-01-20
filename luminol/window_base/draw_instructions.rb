require_relative "draw_types/draw_types"

class DrawInstructions
  def initialize
    @instructions = {}
  end

  # TODO! Just use options hash as a parameter for instructions, no faffing about with the keys
  def add(type, id, options = {})
    case type
    when "text"
      if options[:align]
        @instructions[id] = TextInstruction.new(options[:text], options[:x], options[:y], options[:align])
      else
        @instructions[id] = TextInstruction.new(options[:text], options[:x], options[:y])
      end
    when "color"
      if options[:rect].is_a?(Rect)
        @instructions[id] = ColorInstruction.new(options[:rect], options[:color])
      else
        @instructions[id] = ColorInstruction.new(options[:x], options[:y], options[:width], options[:height], options[:color])
      end
    when "gradient"
      if options[:rect].is_a?(Rect)
        if options[:vertical].nil?
          @instructions[id] = GradientInstruction.new(options[:rect], options[:color1], options[:color2])
        else
          @instructions[id] = GradientInstruction.new(options[:rect], options[:color1], options[:color2], options[:vertical])
        end
      else
        if options[:vertical].nil?
          @instructions[id] = GradientInstruction.new(options[:x], options[:y], options[:width], options[:height], options[:color1], options[:color2])
        else
          @instructions[id] = GradientInstruction.new(options[:x], options[:y], options[:width], options[:height], options[:color1], options[:color2], options[:vertical])
        end
      end
    when "font"
      @instructions[id] = FontInstruction.new(options)
    when "image"
      @instructions[id] = ImageInstruction.new(options)
    when "stretched_image"
      @instructions[id] = StretchedImageInstruction.new(options)
    end
  end

  # Draw will modify the bitmap
  def draw(bitmap)
    bitmap.clear
    @instructions.each { |instruction| instruction.draw(bitmap) }
    return bitmap
  end

  def remove(id)
    @instructions.delete(id)
  end
end
