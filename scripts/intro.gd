extends Node2D

@onready var video = $VideoPlayer

func _ready():
	GameState.show_dialog_sequence(
		[
			{"name": "Noé", "text": "Era uma vez uma história"},
			{"name": "", "text": "Esta é a introdução"},
			{"name": "", "text": "Vamos jogar"},
		],
		false,  # sem escolhas
		"", "",  # sem opções
		self,
		"_on_dialog_finished"
	)

func _on_dialog_finished(_choice = 0):
	video.play()
	video.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
