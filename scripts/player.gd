extends CharacterBody2D

signal dead

var speed = 1.5
var stamina = 2.0
var stamina_max = 2.0
var health = 5.0
var health_max = 5.0
var mana = 5
var last_direction = "up"
var immunity_timer = 1.0
var attacking = false
var can_hit = true
var hit_bodies = []
var alive = true

@onready var animator = $AnimatedSprite2D


func _process(delta: float) -> void:
	if (alive):
		if (animator.animation != "death"):
			_movement_and_animation(delta)
			_attack_system(delta)
			if (immunity_timer > 0):
				immunity_timer -= delta
			move_and_slide()

		animator.play()
	else:
		dead.emit()


func on_hitbox_left_body_entered(body: Node2D) -> void:
	if attacking and body not in hit_bodies:
		body.got_hit(1, self)
		hit_bodies.append(body)


func on_hitbox_right_body_entered(body: Node2D) -> void:
	if attacking and body not in hit_bodies:
		body.got_hit(1, self)
		hit_bodies.append(body)


func on_hitbox_down_body_entered(body: Node2D) -> void:
	if attacking and body not in hit_bodies:
		body.got_hit(1, self)
		hit_bodies.append(body)


func on_hitbox_up_body_entered(body: Node2D) -> void:
	if attacking and body not in hit_bodies:
		body.got_hit(1, self)
		hit_bodies.append(body)


func got_hit(damage: float) -> void:
	if (immunity_timer <= 0):
		health -= damage
		immunity_timer = 1.0
		animator.animation = "got_hit"
		$camera.add_trauma(0.5)
		if (health <= 0):
			animator.animation = "death"


func _movement_and_animation(delta: float) -> void:
	var velocity = Vector2.ZERO

	if (stamina < stamina_max && !Input.is_action_pressed("sprint")):
		stamina += delta * (float)(2.0 / 3.0)
	elif (stamina > stamina_max):
		stamina = stamina_max

	if (Input.is_action_pressed("right")):
		velocity.x += 1
	if (Input.is_action_pressed("left")):
		velocity.x -= 1
	if (Input.is_action_pressed("up")):
		velocity.y -= 1
	if (Input.is_action_pressed("down")):
		velocity.y += 1

	if (velocity.length() > 0):
		if (!attacking):
			if (velocity.x > 0):
				if (immunity_timer < 0):
					animator.animation = "run_right"
				last_direction = "right"
			elif (velocity.x < 0):
				if (immunity_timer < 0):
					animator.animation = "run_left"
				last_direction = "left"
			elif (velocity.y > 0):
				if (immunity_timer < 0):
					animator.animation = "run_front"
				last_direction = "up"
			elif (velocity.y < 0):
				if (immunity_timer < 0):
					animator.animation = "run_back"
				last_direction = "down"

		if (Input.is_action_pressed("sprint") && stamina > 0):
			speed = 2.5
			animator.speed_scale = 1.5
			stamina -= delta
		else:
			animator.speed_scale = 1.0
			speed = 1.5
		velocity = velocity.normalized() * speed
	else:
		if (!attacking):
			match last_direction:
				"up":
					if (immunity_timer < 0):
						animator.animation = "idle_front"
				"down":
					if (immunity_timer < 0):
						animator.animation = "idle_back"
				"left":
					if (immunity_timer < 0):
						animator.animation = "idle_left"
				"right":
					if (immunity_timer < 0):
						animator.animation = "idle_right"

	position += velocity


func _attack_system(delta: float) -> void:
	if Input.is_action_pressed("attack"):
		attacking = true
		var mouse_pos = get_local_mouse_position()
		var angle = rad_to_deg(atan2(mouse_pos.y, mouse_pos.x))

		if angle < 0:
			angle += 360

		if angle < 45 or angle > 315:
			animator.animation = "attack_right"
			animator.flip_h = false
		elif angle > 45 and angle < 135:
			animator.animation = "attack_front"
		elif angle > 135 and angle < 225:
			animator.animation = "attack_right"
			animator.flip_h = true
		elif angle > 225 and angle < 315:
			animator.animation = "attack_back"


func _on_animated_sprite_2d_animation_finished() -> void:
	if (attacking == true):
		animator.flip_h = false
		can_hit = true
		attacking = false
		hit_bodies.clear()
	if (animator.animation == "death"):
		alive = false
