extends CharacterBody2D

signal health_change(new_value)
signal stamina_change(new_value)
signal stamina_max_change(new_value)
signal mana_change(new_value)

var speed = 1.5
var last_direction = "up"
var stamina = 2.0
var stamina_max = 2.0
var health = 5.0
var mana = 5

@onready var animator = $AnimatedSprite2D


func _ready() -> void:
	stamina_max_change.emit(stamina_max)


func _process(delta: float) -> void:
	movement_and_animation(delta)
	move_and_slide()


func movement_and_animation(delta: float) -> void:
	var velocity = Vector2.ZERO

	if (stamina < stamina_max && !Input.is_action_pressed("sprint")):
		stamina += delta * (float)(2.0 / 3.0)
		stamina_change.emit(stamina)
	elif (stamina > stamina_max):
		stamina = stamina_max
		stamina_change.emit(stamina)

	if (Input.is_action_pressed("right")):
		velocity.x += 1
	if (Input.is_action_pressed("left")):
		velocity.x -= 1
	if (Input.is_action_pressed("up")):
		velocity.y -= 1
	if (Input.is_action_pressed("down")):
		velocity.y += 1

	if (velocity.length() > 0):
		if (velocity.x > 0):
			animator.animation = "run_right"
			last_direction = "right"
		elif (velocity.x < 0):
			animator.animation = "run_left"
			last_direction = "left"
		elif (velocity.y > 0):
			animator.animation = "run_front"
			last_direction = "up"
		elif (velocity.y < 0):
			animator.animation = "run_back"
			last_direction = "down"

		if (Input.is_action_pressed("sprint") && stamina > 0):
			speed = 2.5
			animator.speed_scale = 1.5
			stamina -= delta
			stamina_change.emit(stamina)
		else:
			animator.speed_scale = 1.0
			speed = 1.5
		velocity = velocity.normalized() * speed
	else:
		match last_direction:
			"up":
				animator.animation = "idle_front"
			"down":
				animator.animation = "idle_back"
			"left":
				animator.animation = "idle_left"
			"right":
				animator.animation = "idle_right"

	animator.play()
	position += velocity


func _on_max_change(new_value: Variant) -> void:
	pass # Replace with function body.
