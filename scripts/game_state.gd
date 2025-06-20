# game_state.gd
extends Node

# Player position
var return_position: Vector2 = Vector2.ZERO

# Track if levels are completed and their outcomes
var chest_completed = false
var chest_good_choice = false

var window_completed = false
var window_good_choice = false

var mirror_completed = false
var mirror_good_choice = false

# Current active level
var current_level = ""

# Dialogo intro quarto
var intro_bedroom_dialog_shown := false

# Dialog
var dialog_scene = preload("res://scenes/dialog_box.tscn")
var current_dialog = null
var interaction_locked = false
var movement_locked = false

var cores := {
	"mãe": Color("#E17F7F"),
	"noé": Color("#7FB2E1"),
	"outro": Color("#A5A5A5")
}

var puzzle_joias_completo := false

func get_prompt():
	var scene = get_tree().get_current_scene()
	if scene.has_node("Player/Noé/Label"):
		return scene.get_node("Player/Noé/Label")
	return null

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
	
func check_all_levels_completed():
	if chest_completed and window_completed and mirror_completed:
		get_tree().change_scene_to_file("res://scenes/quarto_final.tscn")

func get_good_choice_count() -> int:
	var count = 0
	if chest_completed and chest_good_choice:
		count += 1
	if window_completed and window_good_choice:
		count += 1
	if mirror_completed and mirror_good_choice:
		count += 1
	return count

func check_all_levels_completed_or_return():
	if chest_completed and window_completed and mirror_completed:
		print("Todas as escolhas feitas — a ir para quarto_final.")
		get_tree().change_scene_to_file("res://scenes/quarto_final.tscn")
	else:
		print("Ainda faltam escolhas — a voltar ao main.tscn.")
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func reset_game_state():
	chest_completed = false
	chest_good_choice = false

	window_completed = false
	window_good_choice = false

	mirror_completed = false
	mirror_good_choice = false

	current_level = ""
	current_dialog = null
	interaction_locked = false
	movement_locked = false
	
	intro_bedroom_dialog_shown = false
	
	puzzle_joias_completo = false
	
	return_position = Vector2.ZERO
