require_relative "draw_types/draw_types"

class DrawInstructions
  def initialize
    @instructions = {}
  end

  # TODO! Just use options hash as a parameter for instructions, no faffing about with the keys
  def add(id, instruction)
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
