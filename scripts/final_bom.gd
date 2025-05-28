extends Node2D

@onready var video = $VideoPlayer

func _ready():
	GameState.show_dialog_sequence(
		[
			{"name": "", "text": "[font_size=20]Este foi um dos dois finais do jogo."},
			{"name": "", "text": "[font_size=20]Dependendo das tuas escolhas, o final e os visuais do jogo modificam."},
			{"name": "", "text": "[font_size=20]Queres voltar a jogar?"},
		],
		true,  # com escolhas
		"Tentar outra vez!", "Por hoje não.",  # com opções
		self,
		"_on_dialog_finished"
	)

func _on_dialog_finished(_choice = 0):
	if _choice == 0:
		GameState.reset_game_state()
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	else:
		get_tree().quit()
