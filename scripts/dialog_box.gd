extends CanvasLayer

signal choice_made(choice_index)
signal dialog_finished # 

@onready var dialog_text = $Panel/DialogText
@onready var good_choice_button = $Panel/GoodChoiceButton
@onready var bad_choice_button = $Panel/BadChoiceButton
@onready var continue_label = $Panel/ContinueLabel 

var dialog_lines = []
var current_line = 0
var show_choices_after = false
var final_choices = []

var selected_choice = 0  # 0 = good, 1 = bad
var choosing = false
var can_continue = false

# Borda de botao selecionado
var border_style := StyleBoxFlat.new()
var empty_style := StyleBoxFlat.new()

func set_dialog_sequence(lines: Array, show_choices := false, good_text := "", bad_text := ""):
	dialog_lines = lines
	current_line = 0
	show_choices_after = show_choices
	final_choices = [good_text, bad_text]

	_update_text()

func _update_text():
	dialog_text.text = ""
	continue_label.visible = false
	good_choice_button.visible = false
	bad_choice_button.visible = false
	choosing = false
	can_continue = false

	_start_typewriter(dialog_lines[current_line])

func _start_typewriter(text: String) -> void:
	dialog_text.text = ""
	var char_index = 0

	while char_index < text.length():
		dialog_text.text += text[char_index]
		char_index += 1
		await get_tree().create_timer(0.03).timeout

	continue_label.visible = true
	can_continue = true

func _process(_delta):
	if choosing:
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			selected_choice = 1 - selected_choice
			_update_choice_highlight()

		if Input.is_action_just_pressed("interact"):
			if selected_choice == 0:
				_on_good_choice_pressed()
			else:
				_on_bad_choice_pressed()
	elif can_continue and Input.is_action_just_pressed("interact"):
		current_line += 1
		if current_line >= dialog_lines.size():
			if show_choices_after:
				_show_choices()
			else:
				emit_signal("dialog_finished") #
				queue_free() #

		else:
			_update_text()

func _show_choices():
	# Inicializar o estilo de borda se ainda não tiver sido feito
	border_style.set_border_width_all(3)
	border_style.border_color = Color(1, 1, 1)  # Branco
	empty_style.set_border_width_all(0)

	# 
	continue_label.visible = false
	can_continue = false
	good_choice_button.text = final_choices[0]
	bad_choice_button.text = final_choices[1]
	good_choice_button.visible = true
	bad_choice_button.visible = true
	selected_choice = 0
	_update_choice_highlight()
	choosing = true
	

func _update_choice_highlight():
	var white = Color(1, 1, 1)

	# Mantém o texto sempre branco
	good_choice_button.add_theme_color_override("font_color", white)
	bad_choice_button.add_theme_color_override("font_color", white)

	# Aplica borda branca apenas no botão selecionado
	var is_good_selected = selected_choice == 0
	good_choice_button.add_theme_stylebox_override("normal", border_style if is_good_selected else empty_style)
	bad_choice_button.add_theme_stylebox_override("normal", border_style if not is_good_selected else empty_style)

func _on_good_choice_pressed():
	emit_signal("choice_made", 0)
	queue_free()

func _on_bad_choice_pressed():
	emit_signal("choice_made", 1)
	queue_free()
