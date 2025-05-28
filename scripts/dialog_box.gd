extends CanvasLayer 

signal choice_made(choice_index)
signal dialog_finished

@onready var panel = $Panel
@onready var dialog_text: RichTextLabel = $Panel/DialogText
@onready var good_choice_button = $Panel/GoodChoiceButton
@onready var bad_choice_button = $Panel/BadChoiceButton
@onready var continue_label = $Panel/ContinueLabel

var dialog_lines = []
var current_line = 0
var show_choices_after = false
var final_choices = []
var selected_choice = 0
var choosing = false
var can_continue = false

var border_style := StyleBoxFlat.new()
var empty_style := StyleBoxFlat.new()

var is_typing = false
var skip_typewriter = false


func _ready():
	var white = Color.WHITE
	
	# Estilo de fundo do painel
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0)
	var forced_theme := Theme.new()
	forced_theme.set_stylebox("panel", "Panel", panel_style)
	panel.theme = forced_theme

	# Fonte personalizada
	var font_regular = FontFile.new()
	font_regular.font_data = load("res://fonts/Lapture_Regular.ttf")
	var font_bold = FontFile.new()
	font_bold.font_data = load("res://fonts/Lapture_Bold.ttf")

	dialog_text.add_theme_color_override("font_color", white)
	dialog_text.add_theme_font_override("normal_font", font_regular)
	dialog_text.add_theme_font_override("bold_font", font_bold)
	dialog_text.bbcode_enabled = true

	continue_label.add_theme_color_override("font_color", white)
	continue_label.add_theme_font_override("font", font_regular)
	continue_label.add_theme_font_size_override("font_size", 16)

	good_choice_button.add_theme_color_override("font_color", white)
	good_choice_button.add_theme_font_override("font", font_regular)
	good_choice_button.add_theme_font_size_override("font_size", 18)
	
	bad_choice_button.add_theme_color_override("font_color", white)
	bad_choice_button.add_theme_font_override("font", font_regular)
	bad_choice_button.add_theme_font_size_override("font_size", 18)

	dialog_text.clear()

func set_dialog_sequence(lines: Array, show_choices := false, good_text := "", bad_text := "", character_name := ""):
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

	var current_entry = dialog_lines[current_line]

	if typeof(current_entry) == TYPE_DICTIONARY:
		var name = current_entry.get("name", "")
		var text = current_entry.get("text", "[font_size=20]")
		var color = current_entry.get("color", Color.WHITE)
		_start_typewriter_rich(name, text, color)

	else:
		_start_typewriter_rich("", str(current_entry), "#FFFFFF")

func _start_typewriter_rich(name: String, text: String, color: Color) -> void:
	dialog_text.clear()
	dialog_text.visible_characters = 0
	skip_typewriter = false
	is_typing = true

	var full_text = ""
	if name != "":
		full_text += "[font_size=20][color=" + color.to_html(false) + "][b]" + name + ":[/b][/color] "
	full_text += text

	dialog_text.bbcode_enabled = true
	dialog_text.append_text(full_text)

	var total_chars = dialog_text.get_total_character_count()
	for i in range(total_chars + 1):
		# Se o jogador quiser saltar a escrita, mostra tudo imediatamente
		if skip_typewriter:
			dialog_text.visible_characters = total_chars
			break

		dialog_text.visible_characters = i
		await get_tree().create_timer(0.03).timeout

	is_typing = false
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
	elif Input.is_action_just_pressed("interact"):
		if is_typing:
			skip_typewriter = true
		elif can_continue:
			current_line += 1
			if current_line >= dialog_lines.size():
				if show_choices_after:
					_show_choices()
				else:
					emit_signal("dialog_finished")
					queue_free()
			else:
				_update_text()


func _show_choices():
	border_style.set_border_width_all(0)
	border_style.border_color = Color.WHITE
	border_style.bg_color = Color(0, 0, 0, 0)

	empty_style.set_border_width_all(0)
	empty_style.bg_color = Color(0, 0, 0, 0)

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
	var white = Color.WHITE
	good_choice_button.add_theme_color_override("font_color", white)
	bad_choice_button.add_theme_color_override("font_color", white)

	var is_good_selected = selected_choice == 0
	good_choice_button.text = ("→ " + final_choices[0] + " ←") if is_good_selected else final_choices[0]
	bad_choice_button.text = ("→ " + final_choices[1] + " ←") if not is_good_selected else final_choices[1]

	good_choice_button.add_theme_stylebox_override("normal", border_style if is_good_selected else empty_style)
	bad_choice_button.add_theme_stylebox_override("normal", border_style if not is_good_selected else empty_style)

func _on_good_choice_pressed():
	emit_signal("choice_made", 0)
	queue_free()

func _on_bad_choice_pressed():
	emit_signal("choice_made", 1)
	queue_free()
