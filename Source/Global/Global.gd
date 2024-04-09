extends Node

var MainCamera : Camera3D = null

enum {
	Rogue,
	Knight,
	Barbar,
	Mage,
	Skelenny,
	Skeliny
}

enum {
	CHAR_NAME,
	CHAR_HP,
	CHAR_AP,
	CHAR_PATH,
	CHAR_SPEED
}

enum Position {
	FighterOne,
	FighterTwo,
	Support,
	Scout
}

const CHAR_INFO = {
	Rogue: ["Rogue", 80, 20, "res://Assets/CharScenes/rogue.tscn", 20],
	Knight: ["Knight", 100, 20, "res://Assets/CharScenes/knight.tscn", 11],
	Barbar: ["Barbar", 100, 30, "res://Assets/CharScenes/barbarian.tscn", 14],
	Mage: ["Mage", 80, 20, "res://Assets/CharScenes/mage.tscn", 10],
	Skelenny: ["Skelenny", 100, 20, "res://Assets/CharScenes/skeleton_warrior.tscn", 12],
	Skeliny: ["Skeliny", 60, 20, "res://Assets/CharScenes/skeleton_minion.tscn", 11]
}

var SELECTION = {
	Position.FighterOne: null,
	Position.FighterTwo: null,
	Position.Support: null,
	Position.Scout: null
}

var ENEMIES_ONE = [
	Skelenny,
	Skeliny,
	Skeliny,
	Skeliny
]

#const SPELLS = {
	#Knight:{
		#Position.FighterOne:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.CASTLING, Moves.SWORD_DROP],
		#Position.FighterTwo:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.CASTLING, Moves.SWORD_DROP],
		#Position.Support:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.CASTLING, Moves.INVISIBILITY],
		#Position.Scout:[[Moves.ATTACK_MELEE, Moves.SKIP, Moves.CASTLING, Moves.FIRE_TORNADO]]
	#},
	#Rogue:{
		#Position.FighterOne:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.SEVERAL_PUNCHES],
		#Position.FighterTwo:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.SEVERAL_PUNCHES],
		#Position.Support:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.SHIELD_PROTECT, ],
		#Position.Scout:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.PARALYZING_CURSE, Moves.EYE_PRECISION],
	#},
	#Barbar:{
		#Position.FighterOne:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.SEMI_SACRIFICE, ],
		#Position.FighterTwo:[Moves.ATTACK_MELEE, Moves.SKIP],
		#Position.Support:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.STAMINA_RESTORE, ],
		#Position.Scout:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.POISON_SWAMP, Moves.ENERGY_DIVISION]
	#},
	#Mage:{
		#Position.FighterOne:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.ZEUS_RAGE],
		#Position.FighterTwo:[Moves.ATTACK_MELEE, Moves.SKIP],
		#Position.Support:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.POWER_OF_LIFE, ],
		#Position.Scout:[Moves.ATTACK_MELEE, Moves.SKIP, Moves.STORMY_WEATHER]
	#}
#}

func _ready():
	randomize()
