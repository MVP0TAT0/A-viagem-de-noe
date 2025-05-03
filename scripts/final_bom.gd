extends Node2D

@onready var video = $VideoPlayer

func _ready():
	GameState.show_dialog_sequence(
		[
			{"name": "", "text": "[ Este foi um dos dois finais do jogo. ]"},
			{"name": "", "text": "[ Dependendo das tuas escolhas, o final muda. ]"},
			{"name": "", "text": "[ Queres voltar a jogar? ]"},
		],
		true,  # com escolhas
		"Sim", "Não",  # com opções
		self,
		"_on_dialog_finished"
	)

func _on_dialog_finished(_choice = 0):
	if _choice == 0:
		GameState.reset_game_state()
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	else:
		get_tree().quit()
