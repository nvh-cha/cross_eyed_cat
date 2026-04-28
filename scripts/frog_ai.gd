extends CharacterBody2D

const SPEED: int = 130
const KNOCKBACK_FORCE: int = 100

var target = null
var timer = 0
var timer_max = 2.0
var finished = false
var hp = 4


func _process(delta: float) -> void:
	if (target):
		if (target.position.x > position.x):
			$animator.set_flip_h(true)
		else:
			$animator.set_flip_h(false)

		timer += delta
		if (timer >= timer_max):
			$animator.animation = "jump"
			attack(delta)
			if (finished):
				timer = 0
				finished = false
				$animator.animation = "idle"

	$animator.play()
	move_and_slide()


func attack(delta: float) -> void:
	var direction = (target.position - position).normalized()
	position += direction * SPEED * delta


func got_hit(damage: float, body) -> void:
	hp -= 2
	var knockback = (position - body.position).normalized()
	var end_pos = knockback * KNOCKBACK_FORCE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", end_pos, 0.5)


func _on_sight_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
		target = body


func _on_animator_animation_finished() -> void:
	finished = true
