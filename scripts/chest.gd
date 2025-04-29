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

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	if not GameState.chest_completed:
		GameState.show_dialog_sequence(
			["(A janela está semi-aberta)",
			"(Sentes um leve vento a bater-te na cara)",
			"...!?"
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
	print("A mudar de nível para: ", level_scene)
	GameState.current_level = "chest"
	get_tree().change_scene_to_file(level_scene)

func show_nothing_happens_dialog():
	if GameState.chest_good_choice:
		GameState.show_dialog_sequence(["O mundo lá fora já não me assusta tanto."], false, "", "", self, "_on_nothing_dialog_finished")
	else:
		GameState.show_dialog_sequence(["Não preciso do mundo lá fora..."], false, "", "", self, "_on_nothing_dialog_finished") 

func _on_nothing_dialog_finished(_choice = 0):
	# Só serve para fechar o diálogo
	pass

func update_appearance():
	var sprite = get_parent()  # Acedemos ao Sprite2D

	if not GameState.chest_completed:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_neutral.png")
	elif GameState.chest_good_choice:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_good.png")
	else:
		sprite.texture = load("res://assets/ViagemDeNoe/chest_bad.png")
