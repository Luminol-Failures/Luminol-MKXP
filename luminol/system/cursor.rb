class Cursor
  def initialize
    @sprite = Sprite.new
    @sprite.z = 99999 # Always on top
    @sprite.bitmap = $system.cursor(:normal)

    @diagonal = false
    @diagonal_angle = 0
    @tile_locked = false
    # Offset values from the closest tile (basically, in order to make the cursor look like it's on the tile)
    # It should range from -16 to 16 (32px)
    @tile_locked_x = 0
    @tile_locked_y = 0
  end

  def update
    @sprite.visible = MKXP.mouse_in_window
    @sprite.x = Input.mouse_x
    @sprite.y = Input.mouse_y
  end

  def bitmap=(v)
    @sprite.bitmap = v
  end
end
