extends Node2D

@onready var fade_rect = $FadeRect
@onready var audio_player = $FadeRect/AudioPlayer  # <- referencia ao som

func _ready() -> void:
	fade_in()

func show_dialog():
	GameState.show_dialog_sequence(
		[
			{"name": "Noé", "text": "A morte já espreitava há algum tempo, com os olhos frios de Outubro, mas não pensei que ela fosse partir tão cedo.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Lembro-me das palavras dela...", "color": GameState.cores["noé"]},
			{"name": "Mãe (passado)", "text": "Sacrifiquei tudo por ti. Dei-te o mundo.", "color": GameState.cores["mãe"]},
			{"name": "Mãe (passado)", "text": "E tu? INGRATO! PERDIDO!", "color": GameState.cores["mãe"]},
			{"name": "Noé (passado)", "text": "Tu também estavas assustada! Não era só amor, era medo. Era solidão, controlo.", "color": GameState.cores["noé"]},
			{"name": "Mãe (passado)", "text": "Sem mim... nunca serás nada.", "color": GameState.cores["mãe"]},
			{"name": "Noé", "text": "Mas nem tudo foi escuridão... lembro-me de ser criança e adormecer no sofá ao som da sua voz a cantar...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Será que perdê-la pode ser um ponto de viragem para mim?", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Talvez... Mas talvez não fosse tudo culpa dela...", "color": GameState.cores["noé"]},
		],
		true,  # Mostrar escolhas no fim
		"Tenho de sair desta prisão",
		"Ela é tudo que eu conheço...",
		self,
		"_on_dialog_choice_made"
	)

func _on_dialog_choice_made(choice_index):
	# Guarda a escolha
	GameState.chest_completed = true
	GameState.chest_good_choice = (choice_index == 0)

	# Previne mais interação durante transição
	GameState.movement_locked = true
	
	if GameState.chest_good_choice:
		audio_player.stream = preload("res://sounds/bau/bau bom.mp3")
	else:
		audio_player.stream = preload("res://sounds/bau/bau mau.mp3")

	# Inicia fade out
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(Callable(self, "_play_choice_sound")).set_delay(0.1)
	tween.tween_callback(Callable(self, "_on_fade_out_complete"))
	
	# Espera um pouco antes de tocar o som para sincronizar com o fade
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
