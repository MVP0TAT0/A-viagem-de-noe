extends Node2D

@onready var fade_rect = $FadeRect
@onready var audio_player = $FadeRect/AudioPlayer

func _ready() -> void:
	fade_in()

func show_dialog():
	GameState.show_dialog_sequence(
		[
			{"name": "Noé", "text": "Ela dizia que lá fora todos me iam usar.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Que só ela me iria amar...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Que lá fora me iam destruir contudo, na realidade, destruído eu já estou...", "color": GameState.cores["noé"]}
		],
		true,  # Mostrar escolhas no fim
		"O amor deveria sufocar assim?",
		"Se eu desaparecer, ninguém vai notar",
		self,
		"_on_dialog_choice_made"
	)

func _on_dialog_choice_made(choice_index):
	# Guarda a escolha
	GameState.window_completed = true
	GameState.window_good_choice = (choice_index == 0)

	# Previne mais interação durante transição
	GameState.movement_locked = true

	if GameState.window_good_choice:
		audio_player.stream = preload("res://sounds/janela/janela bom.mp3")
	else:
		audio_player.stream = preload("res://sounds/janela/janela mau.mp3")

	# Inicia fade out
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(Callable(self, "_play_choice_sound")).set_delay(0.1)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))

func _play_choice_sound():
	audio_player.play()

func _on_fade_out_complete():
	await get_tree().create_timer(1.0).timeout  # Espera com ecrã preto
	GameState.movement_locked = false

	# Verifica se pode voltar ou continuar
	GameState.check_all_levels_completed_or_return()

func fade_in():
	fade_rect.modulate.a = 1.0  # Começa opaco
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
