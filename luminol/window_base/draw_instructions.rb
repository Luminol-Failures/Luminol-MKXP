require_relative "draw_types/draw_types"

class DrawInstructions
  def initialize
    @instructions = {}
  end

  # TODO! Just use options hash as a parameter for instructions, no faffing about with the keys
  def add(id, instruction)
    #ase type
    #hen "text"
    # if options[:align]
    #   @instructions[id] = TextInstruction.new(options[:text], options[:x], options[:y], options[:align])
    # else
    #   @instructions[id] = TextInstruction.new(options[:text], options[:x], options[:y])
    # end
    #hen "color"
    # @instructions[id] = ColorInstruction.new(options[:rect], options[:color])
    #hen "gradient"
    # if options[:vertical].nil?
    #   @instructions[id] = GradientInstruction.new(options[:rect], options[:color1], options[:color2])
    # else
    #   @instructions[id] = GradientInstruction.new(options[:rect], options[:color1], options[:color2], options[:vertical])
    # end
    #hen "font"
    # @instructions[id] = FontInstruction.new(options)
    #hen "image"
    # @instructions[id] = ImageInstruction.new(options)
    #hen "stretched_image"
    # @instructions[id] = StretchedImageInstruction.new(options)
    #nd
    @instructions[id] = instruction
  end

  # Draw will modify the bitmap
  def draw(bitmap)
    @instructions.each { |id, instruction| instruction.draw(bitmap) }
    return bitmap
  end

  def remove(id)
    @instructions.delete(id)
  end
end
