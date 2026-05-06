extends Sprite2D


func _process(delta):
	if (Input.is_action_pressed("ability_1")):
		$ability_1.set_frame_and_progress(1, 0)
	else:
		$ability_1.set_frame_and_progress(0, 0)
	if (Input.is_action_pressed("ability_2")):
		$ability_2.set_frame_and_progress(1, 0)
	else:
		$ability_2.set_frame_and_progress(0, 0)
	if (Input.is_action_pressed("ability_3")):
		$ability_3.set_frame_and_progress(1, 0)
	else:
		$ability_3.set_frame_and_progress(0, 0)
	if (Input.is_action_pressed("ability_4")):
		$ability_4.set_frame_and_progress(1, 0)
	else:
		$ability_4.set_frame_and_progress(0, 0)
