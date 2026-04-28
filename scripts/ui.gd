extends CanvasLayer


func _on_stamina_max_change(new_value: float) -> void:
	$hud.stamina_max_set(new_value)


func _on_stamina_change(new_value: float) -> void:
	$hud.stamina_change(new_value)
