extends CharacterBody2D

const SPEED: int = 130
const KNOCKBACK_FORCE: int = 400 # increased since it now decays properly

var target = null
var timer = 0
var timer_max = 2.0
var finished = false
var hp = 4
var knockback = Vector2.ZERO
var alive = true


func _physics_process(delta: float) -> void:
	if (alive):
		knockback = knockback.lerp(Vector2.ZERO, 0.15) # 0.15 = smoother decay
		velocity = Vector2.ZERO

		if ($animator.animation == "got_hit" and finished):
			$animator.animation = "idle"

		if (target):
			if (target.position.x > position.x):
				$animator.set_flip_h(true)
			else:
				$animator.set_flip_h(false)
			timer += delta
			if (timer >= timer_max):
				$animator.animation = "jump"
				_attack(delta)
				if (finished):
					timer = 0
					finished = false
					$animator.animation = "idle"

		# if knockback is strong enough, it overrides movement
		if knockback.length() > 10:
			velocity = knockback

		if (hp <= 0):
			$animator.animation = "death"
			target = null

		$animator.play()
		move_and_slide()
	else:
		get_parent().remove_child(self)
		queue_free()


func got_hit(damage: float, body) -> void:
	if (alive):
		hp -= damage
		var knockback_dir = (position - body.position).normalized()
		knockback = knockback_dir * KNOCKBACK_FORCE
		$animator.animation = "got_hit"


func on_hitbox_body_entered(body: Node2D) -> void:
	body.got_hit(1)


func _attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	velocity = direction * SPEED


func _on_sight_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
		target = body


func _on_animator_animation_finished() -> void:
	finished = true
	if ($animator.animation == "death"):
		alive = false
