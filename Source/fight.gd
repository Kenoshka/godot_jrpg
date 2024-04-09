extends Node3D

var CREATURES = []
var ORDER = [];


var turns_counter = 0
var active_creature : Character = null

const character_scene = preload("res://Source/Global/CharacterScene.tscn")

func _ready():
	Global.MainCamera = $CameraRotator/SceneCamera
	$CameraRotator.rotation_degrees.y = randf_range(0, 180)
	for pos in Global.SELECTION:
		var char_num = Global.SELECTION[pos]
		if char_num != null:
			var char_scene = character_scene.instantiate()
			char_scene.Char_name = Global.CHAR_INFO[char_num][Global.CHAR_NAME]
			char_scene.Max_hp = Global.CHAR_INFO[char_num][Global.CHAR_HP]
			char_scene.Max_ap = Global.CHAR_INFO[char_num][Global.CHAR_AP]
			char_scene.model_path = Global.CHAR_INFO[char_num][Global.CHAR_PATH]
			char_scene.SPEED = Global.CHAR_INFO[char_num][Global.CHAR_SPEED]
			char_scene.IS_ALLY = true
			add_child(char_scene)
			CREATURES.append(char_scene)
			char_scene.global_position = $Positions.get_child(pos).global_position
			char_scene.move_made.connect(creature_made_move)
			char_scene.look_at($Enemies/Front.global_position)
	for i in range(0, 4):
		var charid = Global.ENEMIES_ONE[i]
		var char_scene = character_scene.instantiate()
		char_scene.Char_name = Global.CHAR_INFO[charid][Global.CHAR_NAME]
		char_scene.Max_hp = Global.CHAR_INFO[charid][Global.CHAR_HP]
		char_scene.Max_ap = Global.CHAR_INFO[charid][Global.CHAR_AP]
		char_scene.model_path = Global.CHAR_INFO[charid][Global.CHAR_PATH]
		char_scene.SPEED = Global.CHAR_INFO[charid][Global.CHAR_SPEED]
		char_scene.AI = true
		CREATURES.append(char_scene)
		add_child(char_scene)
		char_scene.global_position = $Enemies.get_child(i).global_position
		char_scene.move_made.connect(creature_made_move)
		char_scene.look_at($Positions/Support.global_position)
	make_order()
	$TestTurnTimer.start(5)



func make_order():
	ORDER = CREATURES.duplicate()
	ORDER.sort_custom(func(a, b): return a.SPEED > b.SPEED)

func _on_test_turn_timer_timeout():
	if turns_counter % CREATURES.size() == CREATURES.size() - 1:
		make_order()
	$Interface/MoveLabel.visible = false
	var next_creature = ORDER[turns_counter % CREATURES.size()]
	if active_creature != null:
		active_creature.look_at($Enemies/Front.global_position)
		active_creature.make_turn_status(false)
	next_creature.Creatures = CREATURES
	next_creature.make_turn_status(true)
	active_creature = next_creature
	turns_counter += 1


func creature_made_move(creature, moveid, target):
	$Interface/MoveLabel.visible = true
	$Interface/MoveLabel/Label.text = Moves.INFO[moveid][Moves.INFO_NAME]
	$CameraRotator/SceneCamera.current = true # Переключать на камеру таргета
	Moves.make_move(creature, moveid, target)
	$TestTurnTimer.start(Moves.INFO[moveid][Moves.INFO_TIME]) # Начинать таймер нужно только когда всё сделано


func _process(delta):
	$CameraRotator.rotation_degrees.y += delta * 20


