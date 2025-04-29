# LevelScene.gd
extends Node2D

# Signals to tell the main scene which choice was made
signal good_choice_selected
signal bad_choice_selected

func _ready():
	# Connect button signals
	$GoodChoiceButton.pressed.connect(_on_good_choice_pressed)
	$BadChoiceButton.pressed.connect(_on_bad_choice_pressed)

func _on_good_choice_pressed():
	# Store the choice in global state
	get_node("/root/GameState").last_choice = "good"
	# Change back to main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_bad_choice_pressed():
	# Store the choice in global state
	get_node("/root/GameState").last_choice = "bad"
	# Change back to main scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
