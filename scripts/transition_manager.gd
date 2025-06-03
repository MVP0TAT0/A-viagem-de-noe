extends CanvasLayer

@export var fade_time := 1.5

func start_transition(target_scene_path: String):
	var tween = create_tween()
	tween.tween_callback(Callable(self, "_on_fade_out_complete").bind(target_scene_path))

func _on_fade_out_complete(target_scene_path: String):
	get_tree().change_scene_to_file(target_scene_path)
	await get_tree().process_frame
	await get_tree().create_timer(0.7).timeout

	# Garante que o FadeRect da nova cena começa opaco (se existir)
	var new_fade = get_tree().get_current_scene().get_node_or_null("FadeRect")
	if new_fade:
		new_fade.modulate.a = 1.0

	var tween = create_tween()
	tween.tween_callback(Callable(self, "_on_fade_complete"))

func _on_fade_complete():
	GameState.movement_locked = false  # <--- Movimento desbloqueado aqui
	queue_free()
