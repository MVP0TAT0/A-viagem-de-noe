extends Area2D

var player_inside := false
var dialog_shown := false  # <- nova variável

@onready var prompt = get_tree().get_current_scene().get_node("Player/Noé/TextureRect")

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
	if player_inside and not dialog_shown and not GameState.interaction_locked and GameState.current_dialog == null:
		show_nothing_happens_dialog()

func show_nothing_happens_dialog():
	dialog_shown = true  # <- marca como já mostrado
	GameState.show_dialog_sequence([
		{"name": "Noé", "text": "Lá fora... sempre me chamaram de estranho.", "color": GameState.cores["noé"]},
		{"name": "Noé", "text": "Nunca soube como agir.", "color": GameState.cores["noé"]},
		{"name": "Noé", "text": "Ela dizia que eu não precisava de ninguém além dela.", "color": GameState.cores["noé"]}
	], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	# Só serve para fechar o diálogo
	pass
