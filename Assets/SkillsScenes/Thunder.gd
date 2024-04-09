extends Node3D

var counter = 0
@onready var thunders = [
	$Model/All/Scene/bolt2,
	$Model/All/Scene/bolt1,
	$Model/All/Scene/bolt0
]

@onready var active_thunder : Node3D = null

func _ready():
	active_thunder = $Model/All/Scene/bolt2
	active_thunder.visible = true

func _on_timer_timeout():
	counter += 1
	if counter > 2:
		queue_free()
	else:
		active_thunder.visible = false
		active_thunder = thunders[counter]
		active_thunder.visible = true


