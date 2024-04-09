extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_tween().tween_property(self, "position:y", 8.0, 3)
	get_tree().create_tween().tween_property($Sprite3D, "modulate:a", 0.0, 3)
