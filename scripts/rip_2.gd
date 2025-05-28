extends Area2D

var player_inside := false
@onready var prompt = get_tree().get_current_scene().get_node("Player/Noé/TextureRect")

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true
		if prompt:
			prompt.visible = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false
		if prompt:
			prompt.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	show_nothing_happens_dialog()

func show_nothing_happens_dialog():
	GameState.show_dialog_sequence([
		{"name": "Noé", "text": "Quando, em criança, demonstrei gosto pelo teatro, ela fez questão em mostrar o quanto as pessoas iriam gozar...", "color": GameState.cores["noé"]}
		], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	# Só serve para fechar o diálogo
	pass
