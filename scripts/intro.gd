extends Node2D

@onready var video = $VideoPlayer
@onready var audio_player = $AudioStreamPlayer  
var video_finished = false
var dialog_finished = false

func _ready():
	video.play()
	audio_player.play()
	
	# Esperar 0.8 segundos antes de mostrar o diálogo
	await get_tree().create_timer(0.8).timeout
	
	GameState.show_dialog_sequence(
		[
			{"name": "Mãe", "text": "Não estás pronto. Lá fora ninguém te entende. Aqui estás seguro, comigo...", "color": GameState.cores["mãe"]},
		],
		false,  # sem escolhas
		"", "",  # sem opções
		self,
		"_on_dialog_finished"
	)

	video.connect("finished", Callable(self, "_on_video_finished"))

func _on_dialog_finished(_choice = 0):
	dialog_finished = true
	_check_transition()

func _on_video_finished():
	video_finished = true
	_check_transition()

func _check_transition():
	if video_finished and dialog_finished:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
