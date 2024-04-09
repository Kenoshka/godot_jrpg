extends Label3D

var num = 0
var color = Color.DARK_RED

func _ready():
	position.x = randf_range(-0.5, 0.5)
	position.z = randf_range(-0.5, 0.5)
	$FadeTimer.start(0.8)
	if num is String:
		text = num
		modulate = Color.DARK_ORANGE
	else:
		text = str(num)
		if num > 0:
			modulate = Color.FOREST_GREEN


func _process(delta):
	position.y += delta * 5


func _on_fade_timer_timeout():
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0, 0.5)
	$FreeTimer.start(0.5)


func _on_free_timer_timeout():
	queue_free()
