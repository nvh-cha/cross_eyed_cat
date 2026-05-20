extends CanvasLayer

var transition = "spawn"


func _process(delta):
	if (transition == "spawn" or transition == "death"):
		$load_scene.play(transition)


func on_player_dead() -> void:
	transition = "death"


func on_load_scene_finished(anim_name) -> void:
	print("nigga")
	if (transition == "death"):
		get_tree().reload_current_scene()
	elif (transition == "spawn"):
		transition = "null"
