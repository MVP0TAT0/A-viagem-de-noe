extends Node2D

@onready var fade_rect = $FadeRect
@onready var audio_player = $FadeRect/AudioPlayer

func _ready() -> void:
	fade_rect.modulate.a = 1.0  # Garante que começa opaco IMEDIATAMENTE
	await get_tree().process_frame  # Espera 1 frame para garantir que tudo carregou
	fade_in()

func show_dialog():
	GameState.show_dialog_sequence(
		[
			{"name": "Noé", "text": "Num parque como este lembro-me de ela me defender...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Uns miúdos começaram a atirar-me coisas à cara... nesse dia vi medo nos seus olhos, mas também força.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Toda a minha vida eu...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Eu...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Eu só lhe queria agradar. Só não a queria dececionar.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Mas quem era eu antes de me dobrar ao seu reflexo?", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Ela dizia que era para o meu bem. Então, porque é que magoou?", "color": GameState.cores["noé"]}
		],
		true,  # Mostrar escolhas no fim
		"Não posso continuar assim!",
		"Eu não sou ninguém...",
		self,
		"_on_dialog_choice_made"
	)

func _on_dialog_choice_made(choice_index):
	# Guarda a escolha
	GameState.mirror_completed = true
	GameState.mirror_good_choice = (choice_index == 0)

	# Previne mais interação durante transição
	GameState.movement_locked = true
	
	if GameState.mirror_good_choice:
		audio_player.stream = preload("res://sounds/espelho/epelho bom.mp3")
	else:
		audio_player.stream = preload("res://sounds/espelho/espelho mau.mp3")

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
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
