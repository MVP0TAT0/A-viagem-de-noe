# game_state.gd
extends Node

# Track if levels are completed and their outcomes
var chest_completed = false
var chest_good_choice = false

var window_completed = false
var window_good_choice = false

var mirror_completed = false
var mirror_good_choice = false

# Current active level
var current_level = ""

# Dialog
var dialog_scene = preload("res://scenes/dialog_box.tscn")
var current_dialog = null
var interaction_locked = false

func show_dialog_sequence(lines, show_choices, good_choice_text, bad_choice_text, target, callback_method):
	if current_dialog == null:
		current_dialog = dialog_scene.instantiate()
		get_tree().root.add_child(current_dialog)

	current_dialog.set_dialog_sequence(lines, show_choices, good_choice_text, bad_choice_text)

	var signal_name = "choice_made" if show_choices else "dialog_finished"
	var callable = Callable(target, callback_method)

	if current_dialog.is_connected(signal_name, callable):
		current_dialog.disconnect(signal_name, callable)

	current_dialog.connect(signal_name, callable)

func close_dialog():
	if current_dialog != null:
		current_dialog.queue_free()
		current_dialog = null

		interaction_locked = true
		await get_tree().create_timer(0.3).timeout
		interaction_locked = false

func show_nothing_happens_dialog():
	GameState.show_dialog_sequence(["Nada acontece..."], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	# Não faz nada, só fecha o diálogo
	pass
