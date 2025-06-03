extends Area2D

@export var level_scene = "res://scenes/chest_level.tscn"

var player_inside := false

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	update_appearance()

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
	if not GameState.chest_completed:
		GameState.show_dialog_sequence([
			{"name": "", "text": "[font_size=20](Noé olha melancolicamente para o baú)"},
			{"name": "Noé", "text": "Memórias...", "color": GameState.cores["noé"]},
			{"name": "", "text": "[font_size=20](Começa a abri-lo)"},
			],
						false,
			"",
			"",
			self,
			"_on_intro_dialog_finished"
		)
	else:
		print("Nada acontece...")
		show_nothing_happens_dialog()

func _on_intro_dialog_finished(_choice = 0):
	GameState.movement_locked = true

	# Desliga a interação
	set_monitoring(false)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

	var shape = get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true

	# Inicia fade + som
	var fade_rect = get_tree().get_current_scene().get_node("FadeRect")
	if fade_rect:
		# Começa o tween do fade
		var tween = get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)  # Inicia o fade para 1.0 (totalmente opaco)

		# Chama o som *uma vez*, só após o tween do fade ter começado
		var main = get_tree().get_current_scene()
		main.play_interaction_sound("chest")

		# Callbacks do tween (quando o fade terminar, continua a cena)
		tween.tween_callback(Callable(self, "_on_fade_complete"))
	else:
		_on_fade_complete()

func _on_fade_complete():
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo para o fade se completar
	GameState.current_level = "chest"
	GameState.movement_locked = false
	
	var player = get_tree().get_current_scene().get_node("Player")
	if player:
		GameState.return_position = player.global_position
	
	get_tree().change_scene_to_file(level_scene)

func show_nothing_happens_dialog():
	if GameState.chest_good_choice:
		GameState.show_dialog_sequence(
			[
				{"name": "Noé", "text": "Talvez não tenha sido só culpa dela. Mas não posso continuar nesta sombra.", "color": GameState.cores["noé"]},
				{"name": "Noé", "text": "O amor dela pedia silêncio. O meu... pedia ar.", "color": GameState.cores["noé"]},
			],
			false, "", "", self, "_on_nothing_dialog_finished")
	else:
		GameState.show_dialog_sequence(
			[
				{"name": "Noé", "text": "Ela tinha razão...", "color": GameState.cores["noé"]},
			],
			false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	pass

func update_appearance():
	var sprite = get_parent()
	if not GameState.chest_completed:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_neutral.png")
	elif GameState.chest_good_choice:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_good.png")
	else:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_bad.png")
