extends Node3D
class_name Character

var move_button = preload("res://Source/MoveButton.tscn")

signal move_made(char, move_id, target)

var Char_name = ""

var IS_ALLY = false

var Max_hp = 100
var Max_ap = 100

var base_strength = -25
var base_accuracy = 0.65

var BUFFS = {}

var ALIVE = true
#var POSITION = Global.Position ДОДЕЛАТЬ
var SKIPS = 0
var HIDDEN = false:
	set(val):
		HIDDEN = val
		$Bush.visible = val

var STEPS_IN_ROW = 1
var SPEED = 0

var health_label_scene = preload("res://Source/health_label.tscn")
var ap_label_scene = preload("res://Source/ap_label.tscn")
var hpbar_scene = preload("res://Source/hpbar.tscn")

var shield_scn = preload("res://Source/Shield.tscn")
var shield

var HPBar : Sprite3D


var Creatures = []
var targets = []
var target_counter = 0
var selected_target : Node3D:
	set(val):
		if selected_target != null:
			selected_target.selected_indicator(false)
		if selected_target != null and val == null:
			selected_target.selected_indicator(false)
		selected_target = val
		if val != null:
			selected_target.selected_indicator(true)
			look_at(val.global_position)

var HP = 0:
	set(val):
		if val > Max_hp:
			HP = Max_hp
		elif val <= 0:
			ALIVE = false
			BUFFS.clear()
			HP = 0
			AnimPlayer.play("Death_A")
		else:
			HP = val
		set_bars()

var AP = 0:
	set(val):
		if val > Max_ap:
			AP = Max_ap
		elif val < 0:
			AP = 0
		else:
			AP = val
		set_bars()

var CHAR_POSITION = 0
var selected_move = 0
var Skills = []

var AI = false

var model_path = ""
var AnimPlayer : AnimationPlayer

func _ready():
	$UI.visible = false
	$UI/MovesContainer.visible = false
	$UI/Switches.visible = false
	HP = Max_hp
	AP = Max_ap
	var model = load(model_path).instantiate()
	$Model.add_child(model)
	AnimPlayer = model.get_node_or_null("AnimationPlayer")
	if AnimPlayer.has_animation("Idle"):
		AnimPlayer.play("Idle")
	setup_bar()


func setup_bar():
	var hpbar = hpbar_scene.instantiate()
	$Healthbar.add_child(hpbar)
	HPBar = hpbar
	set_ui()


func set_ui():
	$UI/Name.text = Char_name
	set_bars()

func set_bars():
	$UI/HPBar.max_value = Max_hp
	$UI/APBar.max_value = Max_ap
	$UI/HPBar.value = HP
	$UI/APBar.value = AP
	$UI/HPLabel.text = "%s / %s HP" % [HP, Max_hp]
	$UI/APLabel.text = "%s / %s AP" % [AP, Max_ap]
	if HPBar != null:
		HPBar.scale.x = (float(HP) / float(Max_hp))


#Участок кода с turn и статусами возможно надо поменять

func make_a_move(moveid, target = selected_target):
	$UI.visible = false
	$UI/Switches.visible = false
	if selected_target != null:
		if not selected_target.IS_ALLY:
			HIDDEN = false
	selected_target = null
	move_made.emit(self, moveid, target)

func set_targets(moveid):
	selected_move = moveid
	$UI/MovesContainer.visible = false
	$UI/Switches.visible = true
	targets = []
	match Moves.INFO[selected_move][Moves.INFO_TARGETS]:
		Moves.TargType.SELF:
			make_a_move(selected_move)
		Moves.TargType.ENEMY:
			for enemy : Character in Creatures:
				if not enemy.IS_ALLY:
					targets.append(enemy)
			selected_target = targets[0]
		Moves.TargType.ALL_ENEMIES:
			for enemy : Character in Creatures:
				if not enemy.IS_ALLY:
					targets.append(enemy)
			make_a_move(selected_move, targets)
		Moves.TargType.ALLY:
			for ally : Character in Creatures:
				if ally.IS_ALLY and ally.ALIVE and ally != self:
					targets.append(ally)
			selected_target = targets[0]
		Moves.TargType.ALLIES:
			for ally : Character in Creatures:
				if ally.IS_ALLY and ally.ALIVE and ally != self:
					targets.append(ally)
			make_a_move(selected_move, targets)
		Moves.TargType.DEAD_ALLY:
			for ally : Character in Creatures:
				if ally.IS_ALLY and not ally.ALIVE and ally != self:
					targets.append(ally)
			selected_target = targets[0]
		Moves.TargType.SQUAD:
			for ally : Character in Creatures:
				if ally.IS_ALLY and ally.ALIVE:
					targets.append(ally)
			make_a_move(selected_move, targets)
	Global.MainCamera.current = true
	if targets.size() == 0:
		selected_target == null



func _on_cancel_move_pressed():
	if selected_target != null:
		selected_target.selected_indicator(false)
	$MainCamera.current = true
	$UI/MovesContainer.visible = true
	$UI/Switches.visible = false


func _on_make_move_pressed():
	if selected_target != null:
		make_a_move(selected_move)


func make_turn_status(status):
	if status:
		if SKIPS > 0:
			SKIPS -= 1
			move_made.emit(self, Moves.SKIP, selected_target)
		else:
			handle_buffs()
			$StartTurn.start(0.5)

	else:
		$UI.visible = status

func _on_start_turn_timeout():
	start_turn()

func start_turn():
	if not ALIVE:
		make_a_move(Moves.DEATH)
	else:
		if AI:
			var move = calculate_move()
		else:
			set_attacks()
			$UI.visible = true
			$MainCamera.current = true


func calculate_move():
	return null

func handle_buffs():
	for buff in BUFFS:
		BUFFS[buff] -= 1
		if BUFFS[buff] < 0:
			Buffs.stop_buff(self, buff)
			BUFFS.erase(buff)
		else:
			Buffs.handle_buff(self, buff)


func set_attacks():
	$UI/MovesContainer.visible = true
	for child in $UI/MovesContainer.get_children():
		child.queue_free()
	for mid in [Moves.RAIN_OF_BLADES, Moves.POISON_SWAMP, Moves.SPEED_BOOST, Moves.INVISIBILITY]: # Временное решение, получать их из глобального хранилища персонажей
		var move_butt = move_button.instantiate()
		move_butt.move_id = mid
		move_butt.pressed.connect(set_targets.bind(mid))
		var price = Moves.get_price(self, mid)
		if price > AP:
			move_butt.disabled = true
		$UI/MovesContainer.add_child(move_butt)


func deal_damage(power, timer_time):
	var timer = Timer.new()
	timer.timeout.connect(
		func _timeout():
			if power == null:
				var hp_label = health_label_scene.instantiate()
				hp_label.position = $Healthbar.position
				hp_label.num = "Miss"
				$Model.add_child(hp_label)
				timer.queue_free()
			else:
				if shield == null:
					HP += power
					var hp_label = health_label_scene.instantiate()
					hp_label.position = $Healthbar.position
					hp_label.num = power
					$Model.add_child(hp_label)
					if power < 0:
						if AnimPlayer.has_animation("Hit_B"):
							AnimPlayer.play("Hit_B")
					AnimPlayer.queue("Idle")
					timer.queue_free()
				else:
					var hp_label = health_label_scene.instantiate()
					hp_label.position = $Healthbar.position
					hp_label.num = "Protected"
					$Model.add_child(hp_label)
					timer.queue_free()
					shield.queue_free()
					shield = null
	)
	add_child(timer)
	timer.start(timer_time)


func restore_ap(restore_amount):
	AP += restore_amount
	var ap_label = ap_label_scene.instantiate()
	ap_label.position = $Healthbar.position
	ap_label.num = restore_amount
	$Model.add_child(ap_label)


func create_shield():
	if shield == null:
		var sh = shield_scn.instantiate()
		add_child(sh)
		shield = sh


func change_target(step):
	if targets.size() > 0:
		target_counter += step
		selected_target = targets[target_counter % targets.size()]


func selected_indicator(boolean):
	$Arrow.visible = boolean

