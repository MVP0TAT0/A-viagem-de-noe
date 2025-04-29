extends Sprite2D

@export var target_scene = "res://scenes/level.tscn"

# Preload the textures
@export var good_texture: Texture2D
@export var bad_texture: Texture2D
@export var default_texture: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Use the default texture initially
	texture = default_texture
	
	# Check if coming back from the level scene with a choice
	var game_state = get_node("/root/GameState")
	
	if game_state.last_choice == "good":
		texture = good_texture
		game_state.last_choice = "" # Reset the choice
	elif game_state.last_choice == "bad":
		texture = bad_texture
		game_state.last_choice = "" # Reset the choice


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		print("Interaction!")
		get_tree().change_scene_to_file(target_scene)
