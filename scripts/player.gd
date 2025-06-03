extends Node2D

@onready var sprite = $Noé
@export var speed := 250

# Limites de movimento
@export var min_x := 20
@export var max_x := 2455

func _ready():
	$"Noé/Label".visible = false

func _process(delta):
	if GameState.current_dialog != null or GameState.movement_locked:
		sprite.animation = "idle"
		return  # Bloqueia movimento durante diálogo ou fade

	# Impede sair dos limites
	position.x = clamp(position.x, min_x, max_x)

	var direction := 0

	if Input.is_action_pressed("ui_left"):
		direction -= 1
	elif Input.is_action_pressed("ui_right"):
		direction += 1

	position.x += direction * speed * delta

	# Vira o sprite para a direção que anda
	if direction != 0:
		sprite.flip_h = direction < 0
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
