extends Area2D

var player_inside := false

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false

func _process(_delta):
	if player_inside and not GameState.intro_bedroom_dialog_shown and not GameState.interaction_locked and GameState.current_dialog == null:
		show_nothing_happens_dialog()

func show_nothing_happens_dialog():
	GameState.intro_bedroom_dialog_shown = true  # <- marca como já mostrado globalmente
	GameState.show_dialog_sequence([
		{"name": "Noé (confuso)", "text": "O que... onde estou? O que se passa?", "color": GameState.cores["noé"]},
		{"name": "Noé", "text": "Ouvi a voz da minha mãe, mas é impossível!", "color": GameState.cores["noé"]},
		{"name": "Noé", "text": "Contudo, ao invés de me encher a alma de esperança, cobriu-me de agoiro...", "color": GameState.cores["noé"]},
		{"name": "", "text": "[font_size=20](Noé olha à sua volta)", "color": GameState.cores["noé"]},
		{"name": "Noé", "text": "Eu conheço este lugar! Mas parece tudo... quieto demais.", "color": GameState.cores["noé"]}
	], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	pass
