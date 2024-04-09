extends Control

const option = preload("res://Source/character_option.tscn")
var selected_butt

var SELECTION : Dictionary


func _ready():
	SELECTION = {
		$Area/Buttons/FighterOneButt: null,
		$Area/Buttons/FighterTwoButt: null,
		$Area/Buttons/SupportButt: null,
		$Area/Buttons/ScoutButt: null
		}
	for butt in $Area/Buttons.get_children():
		pass
		butt.pressed.connect(select_button.bind(butt))
	for charact in Global.CHAR_INFO:
		var opt = option.instantiate()
		opt.pressed.connect(select_option.bind(opt))
		opt.CHAR_NUM = charact
		$Options/ScrollContainer/VBoxContainer.add_child(opt)
	select_button($Area/Buttons/FighterOneButt)

func select_button(button):
	selected_butt = button


func select_option(opt):
	if not SELECTION.values().has(opt):
		SELECTION[selected_butt] = opt
	visualize_selection()


func visualize_selection():
	for opt in $Options/ScrollContainer/VBoxContainer.get_children():
		opt.modulate = Color.WHITE
	for butt in SELECTION:
		if SELECTION[butt] != null:
			SELECTION[butt].modulate = butt.self_modulate


func clear_choise():
	SELECTION = {
		$Area/Buttons/FighterOneButt: null,
		$Area/Buttons/FighterTwoButt: null,
		$Area/Buttons/SupportButt: null,
		$Area/Buttons/ScoutButt: null
		}
	visualize_selection()


func _on_start_button_pressed(): # Переписать под один цикл
	var selected_counter = 0
	for value in SELECTION.values():
		if value != null:
			selected_counter += 1
	if selected_counter > 0:
		for pos in Global.SELECTION:
			if SELECTION[$Area/Buttons.get_child(pos)] != null:
				Global.SELECTION[pos] = SELECTION[$Area/Buttons.get_child(pos)].CHAR_NUM
		get_tree().change_scene_to_file("res://Source/fight.tscn")

