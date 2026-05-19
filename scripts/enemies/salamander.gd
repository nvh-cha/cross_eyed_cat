extends CharacterBody2D

const SPEED: int = 80
const KNOCKBACK: int = 600

var target = null
var hp = 2
var knockback = Vector2.ZERO
var alive = true
var animation_finished = false


func _physics_process(delta: float) -> void:
	if (alive):
		knockback = knockback.lerp(Vector2.ZERO, 0.15)
		velocity = Vector2.ZERO

		if ($animator.animation == "got_hit" and animation_finished):
			$animator.animation = "idle"

		if (target):
			if (target.position.x > position.x):
				$animator.set_flip_h(false)
			else:
				$animator.set_flip_h(true)
			var dir = (target.position - position).normalized()
			velocity = dir * SPEED
			if ($animator.animation != "got_hit"):
				$animator.animation = "run"

		if ($animator.animation == "got_hit" and animation_finished):
			$animator.animation = "idle"

		if (animation_finished):
			animation_finished = false

		if (knockback.length() > 10):
			velocity = knockback

		move_and_slide()
	else:
		if (animation_finished):
			get_parent().remove_child(self)
			queue_free()
	$animator.play()


func got_hit(damage: float, body) -> void:
	if (alive):
		hp -= damage
		var dir = (position - body.position).normalized()
		knockback = dir * KNOCKBACK
		$animator.animation = "got_hit"
		if (hp <= 0):
			alive = false
			$animator.animation = "death"


func on_sight_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
		target = body


func on_animator_animation_finished():
	animation_finished = true
