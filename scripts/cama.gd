extends Area2D

var player_inside := false

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
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	show_nothing_happens_dialog()

func show_nothing_happens_dialog():
	GameState.show_dialog_sequence([
		"A minha cama...", 
		"Aqui é onde passo a maior parte dos meus dias..."
		], false, "", "", self, "_on_nothing_dialog_finished")

func _on_nothing_dialog_finished(_choice = 0):
	# Só serve para fechar o diálogo
	pass
