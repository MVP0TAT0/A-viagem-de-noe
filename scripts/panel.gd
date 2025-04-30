extends Panel

func _ready():
	queue_redraw()

func _draw():
	var dash_len = 5
	var gap = 14
	var thickness = 1
	var color = Color(1, 1, 1)
	var rect = get_rect()
	

	# Topo
	var x = 0
	while x < rect.size.x:
		draw_line(Vector2(x, 0), Vector2(min(x + dash_len, rect.size.x), 0), color, thickness)
		x += dash_len + gap

	# Fundo
	x = 0
	while x < rect.size.x:
		draw_line(Vector2(x, rect.size.y - 1), Vector2(min(x + dash_len, rect.size.x), rect.size.y - 1), color, thickness)
		x += dash_len + gap

	# Esquerda
	var y = 0
	while y < rect.size.y:
		draw_line(Vector2(0, y), Vector2(0, min(y + dash_len, rect.size.y)), color, thickness)
		y += dash_len + gap

	# Direita
	y = 0
	while y < rect.size.y:
		draw_line(Vector2(rect.size.x - 1, y), Vector2(rect.size.x - 1, min(y + dash_len, rect.size.y)), color, thickness)
		y += dash_len + gap
