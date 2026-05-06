extends Camera2D

var decay = 0.8
var max_offset = Vector2(100, 75)
var max_roll = 0.1
var trauma = 0.0
var trauma_pw = 2


func _ready():
	randomize()


func _process(delta):
	trauma = max(trauma - decay * delta, 0)

	var amount = pow(trauma, trauma_pw)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)


func add_trauma(a):
	trauma = min(trauma + a, 1.0)
