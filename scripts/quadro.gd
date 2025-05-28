extends Sprite2D

const QUADROS = [
	preload("res://assets/ViagemDeNoe/quadro_1.png"),
	preload("res://assets/ViagemDeNoe/quadro_2.png"),
	preload("res://assets/ViagemDeNoe/quadro_3.png"),
	preload("res://assets/ViagemDeNoe/quadro_4.png"),
]

func _ready():
	set_process(true)  # Ativa o _process

func _process(_delta):
	update_quadro()

func update_quadro():
	var completed_count = 0
	if GameState.chest_completed:
		completed_count += 1
	if GameState.window_completed:
		completed_count += 1
	if GameState.mirror_completed:
		completed_count += 1

	texture = QUADROS[completed_count]
