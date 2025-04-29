extends Control


func _ready() -> void:
	var screen_size = get_viewport_rect().size  # Get the screen size
	var texture_size = $background.texture.get_size()  # Get the image size
	
	# Center the background
	$background.position = screen_size / 2

	# Scale it to fit the screen
	var scale_x = screen_size.x / texture_size.x
	var scale_y = screen_size.y / texture_size.y
	$background.scale = Vector2(scale_x, scale_y)
