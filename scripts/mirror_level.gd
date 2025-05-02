# mirror_level.gd (similar for other levels)
extends Node2D

func show_dialog():
	GameState.show_dialog_sequence(
		[
			"bla bla",
			"Que pretendes fazer?"
		],
		true,  # Mostrar escolhas no fim
		"Abrir a janela",
		"Fechar a janela",
		self,
		"_on_dialog_choice_made"
	)

func _on_dialog_choice_made(choice_index):
	# Process the player's choice
	if choice_index == 0: # Good choice
		GameState.mirror_completed = true
		GameState.mirror_good_choice = true
	else: # Bad choice
		GameState.mirror_completed = true
		GameState.mirror_good_choice = false

	# Verificar se os níveis foram todos completos
	GameState.check_all_levels_completed_or_return()
