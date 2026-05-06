extends CanvasLayer

var transition = "spawn"


func _process(delta):
	if (transition == "spawn" or transition == "respawn"):
		$load_scene.play()


func on_player_dead() -> void:
	transition = "respawn"
	$load_scene.animation = "respawn"


func on_load_scene_finished() -> void:
	if (transition == "respawn"):
		get_tree().reload_current_scene()
	elif (transition == "spawn"):
		transition = "null"
