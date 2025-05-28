extends Node2D

@onready var video = $VideoPlayer

func _ready():
	video.play()
	video.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	GameState.show_dialog_sequence(
		[
			{"name": "", "text": "[font_size=20]Esta é a história de Noé."},
			{"name": "", "text": "[font_size=20]Pensas que já acabou? Não."},
			{"name": "", "text": "[font_size=20]As tuas escolhas levaram Noé a cair num ciclo de repetição até encontrar rumo para a sua vida."},
			{"name": "", "text": "[font_size=20]Como já deves ter percebido, dependendo das tuas escolhas, o final e os visuais do jogo modificam."},
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
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		get_tree().quit()
