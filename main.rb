# The setup for this is gonna be weird but i assure you it WILL work i think

require_relative "luminol/system/system"
require_relative "luminol/scenes/scene_mapedit"

working_dir = "D:/Git/OSFM-GitHub"
Font.default_name = "Terminus (TTF)"
$system = System.new
$system.working_dir = working_dir

Graphics.frame_rate = 60

$scene = Scene_MapEdit.new
while $scene != nil
  $scene.main
end

print "Shutting down..."
