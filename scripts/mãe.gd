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
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	var good_count = GameState.get_good_choice_count()
	var bad_count = 3 - good_count

	if good_count > bad_count:
		GameState.show_dialog_sequence([
			"Conseguiste fazer as escolhas certas.",
			"Estou orgulhosa de ti. Está na hora de sair da bolha."
		], false, "", "", self, "_on_final_dialog_finished")
	else:
		GameState.show_dialog_sequence([
			"Fizeste muitas escolhas erradas.",
			"Ainda não estás preparado para sair..."
		], false, "", "", self, "_on_final_dialog_finished")

func _on_final_dialog_finished(_choice = 0):
	print("Final terminado — podes mudar para créditos ou reinício aqui.")
