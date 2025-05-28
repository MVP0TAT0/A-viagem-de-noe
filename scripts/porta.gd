extends Area2D

var player_inside := false
var dialog_shown := false
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

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false

func _process(_delta):
	if not dialog_shown and player_inside and GameState.current_dialog == null:
		interact()

func interact():
	var good_count = GameState.get_good_choice_count()
	var bad_count = 3 - good_count

	if good_count > bad_count:
		# Final bom → mostra diálogo
		GameState.show_dialog_sequence(
			[
				{"name": "Noé (calmo)", "text": "Aceitar não é esquecer. É transformar o que doeu em força.", "color": GameState.cores["noé"]}
			],
			false, "", "", self, "_on_dialog_finished"
		)
	else:
		# Final mau → salta diretamente para fade
		dialog_shown = true
		GameState.movement_locked = true
		_start_fade()

func _start_fade():
	var fade_rect = $"../../FadeRect"
	if fade_rect:
		var tween = get_tree().create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
		tween.tween_callback(Callable(self, "_on_fade_complete"))
	else:
		_on_fade_complete()


func _on_dialog_finished(_choice = 0):
	dialog_shown = true
	GameState.movement_locked = true
	_start_fade()


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
