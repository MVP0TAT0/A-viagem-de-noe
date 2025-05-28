extends Node2D

@onready var fade_rect = $FadeRect
@onready var dark_overlay = $DarkOverlay
@onready var sound_player = $InteractionSoundPlayer  # Referência ao AudioStreamPlayer

func _ready() -> void:
	if GameState.return_position != Vector2.ZERO:
		var player = $Player
		if player:
			player.global_position = GameState.return_position
			GameState.return_position = Vector2.ZERO  # Limpa para evitar aplicar novamente
	
	# Apresenta visual inicial com fade-in
	fade_in()
	update_dark_overlay_opacity()

	# Atualiza os objetos (como já tinhas)
	$Chest/Area2D.update_appearance()
	$Mirror/Area2D.update_appearance()
	$Window/Area2D.update_appearance()

func fade_in():
	var fade_rect = $FadeRect
	fade_rect.modulate.a = 1.0  # Garante que começa opaco
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func update_dark_overlay_opacity():
	var completed_count = 0
	if GameState.chest_completed:
		completed_count += 1
	if GameState.window_completed:
		completed_count += 1
	if GameState.mirror_completed:
		completed_count += 1

	# Define os valores de opacidade (em 0–255)
	var alpha := 0
	match completed_count:
		1:
			alpha = 40
		2:
			alpha = 70
		3:
			alpha = 100
		_:
			alpha = 0

	# Atualiza o modulate do ColorRect
	var color = dark_overlay.color
	color.a8 = alpha  # Usa a versão em 0–255 para precisão
	dark_overlay.color = color

# Função que toca o som correto com base no objeto
func play_interaction_sound(object_name: String):
	var sound : AudioStream = null

	# Definir o som com base no nome do objeto
	match object_name:
		"chest":
			sound = load("res://sounds/bau/abrir bau.mp3")
		"mirror":
			sound = load("res://sounds/espelho/abrir espelho.mp3")
		"window":
			sound = load("res://sounds/janela/abrir janela.mp3")
		_:
			print("Objeto desconhecido!")
			return

	# Definir o áudio no player e tocar
	sound_player.stream = sound
	sound_player.play()
