extends Area2D

var player_inside := false
var dialog_shown := false

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
		interact()

func interact():
	dialog_shown = true
	var level = get_tree().get_current_scene()
	if level.has_method("show_dialog"):
		level.show_dialog()
