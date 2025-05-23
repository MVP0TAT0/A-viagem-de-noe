extends Control

const first_scene = preload("res://scenes/intro.tscn")

@onready var selector_one = $Seta
@onready var selector_two = $Seta2
@onready var selector_three = $Seta3

var current_selection = 0

func _ready():
	set_current_selection(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("interact"):
		handle_selection(current_selection)  # Chama a função de seleção

func handle_selection(_current_selection):
	if _current_selection == 0:
		# Vai para a cena principal apenas se a seleção for 0
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	elif _current_selection == 1:
		print("Add!")
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"
