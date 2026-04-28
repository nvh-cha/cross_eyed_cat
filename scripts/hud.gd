extends AnimatedSprite2D

var stamina_max: float = 0.0
var stamina = stamina_max


func _process(delta: float) -> void:
	# x : 31 = s : sm
	$stamina.set_frame_and_progress(31 - (int)(31 * stamina / stamina_max), 0.0)
	play()


func stamina_max_set(val: float) -> void:
	stamina_max = val
	stamina = val


func stamina_change(val: float) -> void:
	stamina = val
