extends Control

const first_scene = preload("res://scenes/intro.tscn")

@onready var selector_one = $Seta
@onready var selector_three = $Seta3

var current_selection = 0

func _ready():
	set_current_selection(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if Input.is_action_just_pressed("ui_right") and current_selection < 1:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_left") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("interact"):
		handle_selection(current_selection)

func handle_selection(_current_selection):
	if _current_selection == 0:
		get_tree().change_scene_to_file("res://scenes/intro.tscn")
	elif _current_selection == 1:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_three.text = ">"
