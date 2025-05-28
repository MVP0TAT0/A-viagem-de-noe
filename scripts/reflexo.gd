extends Node2D

@export var player_path: NodePath  # Caminho até ao nó do jogador
@onready var player = get_node(player_path)
@onready var sprite = $AnimatedSprite2D

func _process(_delta):
	if player == null:
		return

	# Calcula a posição relativa do jogador em relação ao espelho
	var global_player_pos = player.global_position
	var global_self_pos = global_position
	var local_relative_pos = to_local(global_player_pos)

	# Mover apenas o sprite (dentro da máscara)
	sprite.position.x = -local_relative_pos.x - 100

	# Copiar animação
	var player_anim = player.get_node("Noé").animation
	if sprite.animation != player_anim:
		sprite.play(player_anim)

	# Copiar orientação (espelhada horizontalmente como num espelho)
	sprite.flip_h = !player.get_node("Noé").flip_h
