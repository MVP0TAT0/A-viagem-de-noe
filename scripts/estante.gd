extends Area2D

var player_inside := false

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true
		if GameState.get_prompt():
			GameState.get_prompt().visible = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false
		if GameState.get_prompt():
			GameState.get_prompt().visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	if GameState.puzzle_joias_completo:
		GameState.show_dialog_sequence(
			[
				{"name": "Noé", "text": "A minha estante...", "color": GameState.cores["noé"]},
				{"name": "Noé", "text": "Representa-me bem. Parte é minha, parte é dela...", "color": GameState.cores["noé"]},
			],
			false, "", "", null, ""
		)
	else:
		GameState.show_dialog_sequence([
			{"name": "Noé", "text": "...!", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "A caixa das jóias favoritas dela...", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Se ela visse isto assim, ficaria... desapontada.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Sempre teve um cuidado quase ritual com a ordem das coisas.", "color": GameState.cores["noé"]},
			{"name": "Noé", "text": "Ela dizia sempre que cada peça tinha um lugar, e cada lugar tinha um significado...", "color": GameState.cores["noé"]}
		], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	GameState.movement_locked = true  # Impede o jogador de se mexer
	GameState.interaction_locked = true  # Impede novas interações

	var puzzle_scene = preload("res://scenes/puzzle.tscn")
	var puzzle_instance = puzzle_scene.instantiate()

	var puzzle_container = get_node("../PuzzleContainer")
	puzzle_container.add_child(puzzle_instance)

	puzzle_instance.mostrar_caixa()
