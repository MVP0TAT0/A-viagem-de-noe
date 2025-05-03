extends Area2D

var player_inside := false
var interaction_enabled := true

@onready var prompt = get_tree().get_current_scene().get_node("Player/Noé/TextureRect")

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true
		if prompt and interaction_enabled:
			prompt.visible = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false
		if prompt:
			prompt.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and interaction_enabled and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	interaction_enabled = false  # <-- desativa interação após 1ª vez
	if prompt:
		prompt.visible = false

	var level = get_tree().get_current_scene()
	if level.has_method("show_dialog"):
		level.show_dialog()
