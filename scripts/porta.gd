extends Area2D

var player_inside := false
@onready var prompt = get_tree().get_current_scene().get_node("Player/Noé/TextureRect")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	collision_shape_2d.disabled = true

func ativar_interacao():
	print_debug("✅ Ativar interação da porta chamado!")
	$CollisionShape2D.disabled = false

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
	GameState.show_dialog_sequence(
		[
			{"name": "Noé", "text": "Era uma vez uma história"},
			{"name": "", "text": "Esta é a introdução"},
			{"name": "", "text": "Vamos jogar"},
		],
		false,  # sem escolhas
		"", "",  # sem opções
		self,
		"_on_dialog_finished"
	)

func _on_dialog_finished(_choice = 0):
	GameState.movement_locked = true  # Bloqueia movimento

	# Desliga a interação
	var interaction_area = self
	interaction_area.set_monitoring(false)
	interaction_area.set_deferred("collision_layer", 0)
	interaction_area.set_deferred("collision_mask", 0)

	var shape = interaction_area.get_node_or_null("CollisionShape2D")
	if shape:
		shape.disabled = true

	# Inicia fade
	var fade_rect = $"../../FadeRect"
	if fade_rect:
		var tween = get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
		tween.tween_callback(Callable(self, "_on_fade_complete"))
	else:
		# Se não houver fade_rect, muda diretamente
		_on_fade_complete()

func _on_fade_complete():
	await get_tree().create_timer(1.0).timeout  # 1 segundo de ecrã preto
	GameState.current_level = "chest"
	GameState.movement_locked = false
	
	var good_count = GameState.get_good_choice_count()
	var bad_count = 3 - good_count
	
	if good_count > bad_count:
		get_tree().change_scene_to_file("res://scenes/final_bom.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/final_mau.tscn")
