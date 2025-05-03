extends Node2D

@onready var fade_rect = $FadeRect

func _ready() -> void:
	fade_in()

func show_dialog():
	GameState.show_dialog_sequence(
		[
			{"name": "windooowww", "text": "bla bla"},
			{"name": "testeeee", "text": "Que pretendes fazer?"}
		],
		true,  # Mostrar escolhas no fim
		"Abrir a janela",
		"Fechar a janela",
		self,
		"_on_dialog_choice_made"
	)

func _on_dialog_choice_made(choice_index):
	# Guarda a escolha
	GameState.window_completed = true
	GameState.window_good_choice = (choice_index == 0)

	# Previne mais interação durante transição
	GameState.movement_locked = true

	# Inicia fade out
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _on_fade_out_complete():
	await get_tree().create_timer(1.0).timeout  # Espera com ecrã preto
	GameState.movement_locked = false

	# Verifica se pode voltar ou continuar
	GameState.check_all_levels_completed_or_return()

func fade_in():
	fade_rect.modulate.a = 1.0  # Começa opaco
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
