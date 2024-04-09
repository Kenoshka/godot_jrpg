extends Node3D

func _on_timer_timeout():
	get_tree().create_tween().tween_property($Blades, "position:y", 0.5, 0.5)


func _on_free_timer_timeout():
	queue_free()
