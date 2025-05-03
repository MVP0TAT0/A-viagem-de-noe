extends Area2D

var player_inside := false
@onready var prompt = get_tree().get_current_scene().get_node("Player/Noé/TextureRect")

# Fade
@onready var fade_rect = get_tree().get_current_scene().get_node("FadeRect")
@onready var porta = get_tree().get_current_scene().get_node("porta")
@onready var porta_Area2D = get_tree().get_current_scene().get_node("porta/Area2D")
@onready var nova_textura_porta = preload("res://assets/ViagemDeNoe/porta_aberta.png") # muda este path

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true
		if prompt:
			prompt.visible = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false
		if prompt:
			prompt.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	var good_count = GameState.get_good_choice_count()
	var bad_count = 3 - good_count

	if good_count > bad_count:
		GameState.show_dialog_sequence([
			"Conseguiste fazer as escolhas certas.",
			"Estou orgulhosa de ti. Está na hora de sair da bolha."
		], false, "", "", self, "_on_final_dialog_finished")
	else:
		GameState.show_dialog_sequence([
			"Fizeste muitas escolhas erradas.",
			"Ainda não estás preparado para sair..."
		], false, "", "", self, "_on_final_dialog_finished")

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_fade_to_black_complete"))

func _on_fade_to_black_complete():
	print_debug("Nó porta:", porta)
	print_debug("Nó porta_Area2D:", porta_Area2D)

	var porta_area = get_tree().get_current_scene().get_node_or_null("porta/Area2D")
	if porta_area and porta_area.has_method("ativar_interacao"):
		porta_area.ativar_interacao()
	else:
		print_debug("⚠️ Porta não encontrada ou método ausente!")
	
	# Espera algum tempo com o ecrã totalmente preto antes de continuar
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo

	# Muda a textura da porta
	if porta and nova_textura_porta:
		porta.texture = nova_textura_porta
		porta_Area2D.ativar_interacao()

	# Desaparece com a mãe (e interação)
	var mae = $".."
	if mae:
		mae.visible = false
		mae.set_process(false)
		mae.set_physics_process(false)

	# Fade in de volta ao quarto
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	GameState.movement_locked = false


func _on_final_dialog_finished(_choice = 0):
	# Desativa interação imediatamente após o diálogo
	var mae = $".."
	if mae:
		var interaction_area = mae.get_node_or_null("Area2D")
		if interaction_area:
			interaction_area.set_monitoring(false)
			interaction_area.set_deferred("collision_layer", 0)
			interaction_area.set_deferred("collision_mask", 0)

			var shape = interaction_area.get_node_or_null("CollisionShape2D")
			if shape:
				shape.disabled = true

	GameState.movement_locked = true  # <- Aqui bloqueias o movimento

	# Inicia fade
	fade_out()
