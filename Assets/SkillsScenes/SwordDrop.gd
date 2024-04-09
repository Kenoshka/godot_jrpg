extends Node3D


func _on_free_timer_timeout():
	queue_free()


func _on_timer_timeout():
	var tw = get_tree().create_tween()
	tw.tween_property(self, "position", Vector3(0, -10, 0), 0.5)
