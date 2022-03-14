require_relative 'rpgmaker_classes'

# Conversion table of RMXP command codes to Luminol commands
# Luminol handles commands differently for ease of use (and code)
# Luminol has a seperate object for each different event command
# This should in the future make it easier to patch in custom event commands

TYPE_CONVERSION = {
  Text: 101,
  Choices: 102,

  Unknown: 402,
  Cancel: 403,

  NumberInput: 103,
  TextOptions: 104,
  InputProcessing: 105,
  Wait: 106,

  Conditional: 111,

  Else: 411,

  Loop: 112,

  Repeat: 413,

  Break: 113,
  Exit: 115,
  Erase: 116,
  CommonEvent: 117,
  Jump: 119,
  Switch: 121,
  Variable: 122,
  SelfSwitch: 123,
  Timer: 124,
  Gold: 125,
  Items: 126,
  Weapons: 127,
  Armor: 128,
  Party: 129,
  Windowskin: 131,
  BattleBGM: 132,
  BattleEndME: 133,
  SaveAccess: 134,
  MenuAccess: 135,
  Encounter: 136,

  Move: 201,
  MoveEvent: 202,
  Scroll: 203,
  MapSettings: 204,
  FogTone: 205,
  Animation: 207,
  Transparent: 208,
  MoveRoute: 209,
  WaitForMove: 210,

  PrepareTransition: 221,
  Transition: 222,
  ScreenTone: 223,
  Flash: 224,
  Shake: 225,

  Picture: 231,
  MovePicture: 232,
  RotatePicture: 233,
  PictureTone: 234,
  ErasePicture: 235,
  Weather: 236,

  BGM: 241,
  FadeBGM: 242,
  BGS: 245,
  FadeBGS: 246,
  Memorize: 247,
  Restore: 248,
  ME: 249,
  SE: 250,
  StopSE: 251,

  Battle: 301,

  Win: 601,
  Escape: 602,
  Lose: 603,

  Shop: 302,
  Name: 303,

  HP: 311,
  SP: 312,
  State: 313,
  Recover: 314,
  EXP: 315,
  Level: 316,
  Parameters: 317,
  Skills: 318,
  Equipment: 319,
  ActorName: 320,
  ActorClass: 321,
  ActorGraphic: 322,

  EnemyHP: 331,
  EnemySP: 332,
  EnemyState: 333,
  RecoverEnemy: 334,
  EnemyAppear: 335,
  EnemyTransform: 336,
  BattleAnimation: 337,
  Damage: 338,
  Force: 339,
  Abort: 340,

  Menu: 351,
  Save: 352,
  GameOver: 353,
  TitleScreen: 354,
  Eval: 355,

  # Fallback
  LuminolCommand: -255
}.freeze

INVERT_TYPE_CONVERSION = TYPE_CONVERSION.invert.freeze

class LuminolCommand
  PARAMETER_CHECK = {}.freeze # Overwritten
  PARAMETER_ORDER = {}.freeze # To be overwritten by subclasses

  attr_accessor :indent, :parameters

  def initialize(parameters = {}, indent = 0)
    @parameters = parameters
    @type = self.class.name.to_sym
    @indent = indent
  end

  def display
    'undefined'
  end

  def parameter_types
    PARAMETER_CHECK
  end

  def typecheck(sym, value)
    PARAMETER_CHECK[sym] == value.class.name
  end

  def sort_parameters
    ordered = []
    sort = @parameters.sort_by { |parameter, value| PARAMETER_ORDER[parameter] }
    sort.each do |pair|
      ordered << pair[1]
    end

    ordered
  end

  def unsort_parameters(parameters)
    result = {}
    PARAMETER_ORDER.each do |parameter, order|
      result[parameter] = parameters[order]
    end
    result
  end

  def [](sym)
    @parameters[sym]
  end

  def []=(sym, value)
    typecheck(sym, value)
  end

  def to_rpg
    command = RPGCommand.new
    command.code = TYPE_CONVERSION[@type]
    command.parameters = sort_parameters
    command
  end
end

class RPGCommand < RPG::EventCommand
  def to_luminol
    command = INVERT_TYPE_CONVERSION[@code].constantize.new
    command.parameters = command.unsort_parameters(@parameters)
    command
  end
end

class Symbol
  def constantize
    Kernel.const_get(self)
  end
end
