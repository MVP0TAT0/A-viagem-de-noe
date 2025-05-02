extends Node2D

func _ready() -> void:
	#var screen_size = get_viewport_rect().size
	#var texture_size = $background.texture.get_size()
	#$background.position = screen_size / 2
#
	#var scale_x = screen_size.x / texture_size.x
	#var scale_y = screen_size.y / texture_size.y
	#$background.scale = Vector2(scale_x, scale_y)
	
	# Atualiza a aparência dos objetos (se quiseres garantir 100%)
	$Chest/Area2D.update_appearance()
	$Mirror/Area2D.update_appearance()
	
