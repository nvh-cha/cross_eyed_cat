extends AnimatedSprite2D

var stamina_max = 0.0
var stamina = stamina_max
var health_max = 0.0
var health = health_max
var player = null


func _ready():
	player = get_parent().get_parent().get_node("player")


func _process(delta: float) -> void:
	stamina = player.stamina
	stamina_max = player.stamina_max
	health = player.health
	health_max = player.health_max
	# x : 31 = s : sm
	$stamina.set_frame_and_progress(31 - (int)(31 * stamina / stamina_max), 0.0)
	$health.set_frame_and_progress(54 - (int)(54 * health / health_max), 0.0)
	play()
