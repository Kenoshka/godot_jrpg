extends Button

var CHAR_NUM = Global.Rogue


func _ready():
	$Label.text = Global.CHAR_INFO[CHAR_NUM][Global.CHAR_NAME]
	var max_hp = Global.CHAR_INFO[CHAR_NUM][Global.CHAR_HP]
	var max_ap = Global.CHAR_INFO[CHAR_NUM][Global.CHAR_AP]
	$StatsLabel.text = "HP: %s   AP: %s" % [max_hp, max_ap]
	var model_path = Global.CHAR_INFO[CHAR_NUM][Global.CHAR_PATH]
	var model = load(model_path).instantiate()
	add_child(model)
	model.position.z = CHAR_NUM * 10 # Лютый костыль, скорее всего переделать под World3D
	$TextureRect/SubViewport/Camera3D.position.z = CHAR_NUM * 10


