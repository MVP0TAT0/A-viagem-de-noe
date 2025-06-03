extends Area2D

var player_inside := false
@onready var audio_player: AudioStreamPlayer = $"../../FadeRect/AudioPlayer"
@onready var anim_mae: AnimatedSprite2D = get_parent() # ou $".."

# Fade
@onready var fade_rect = get_tree().get_current_scene().get_node("FadeRect")
@onready var porta = get_tree().get_current_scene().get_node("porta")
@onready var porta_Area2D = get_tree().get_current_scene().get_node("porta/Area2D")
@onready var nova_textura_porta = preload("res://assets/ViagemDeNoe/porta_aberta.png") # muda este path

func _ready():
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
	anim_mae.play("default")

func _on_area_entered(area):
	if area.name == "InteractionArea":
		player_inside = true
		if GameState.get_prompt():
			GameState.get_prompt().visible = true

func _on_area_exited(area):
	if area.name == "InteractionArea":
		player_inside = false
		if GameState.get_prompt():
			GameState.get_prompt().visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_inside and not GameState.interaction_locked and GameState.current_dialog == null:
		interact()

func interact():
	var good_count = GameState.get_good_choice_count()
	var bad_count = 3 - good_count

	# Diálogo fixo que aparece sempre
	var dialogo_inicial = [
		{"name": "Mãe", "text": "Fica comigo. Não precisas de mais nada.", "color": GameState.cores["mãe"]},
		{"name": "Mãe", "text": "Eu cuido de ti, como sempre cuidei.", "color": GameState.cores["mãe"]},
		{"name": "Noé", "text": "A maior parte da minha vida foi vivida à tua volta. Mas era minha?", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "Ou apenas reflexo do que querias?", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "Quando tentei falar, contar como me sentia... não ouviste. Disseste que o mundo era perigoso demais.", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "E eu...", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "... fiquei.", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "Tu censuraste a minha vida!", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "Sempre com medo de errar, de falar...", "color": GameState.cores["noé"]},
		{"name": "Noé (magoado)", "text": "... de não estar à altura do teu amor. Mas amor não devia ser só medo, pois não?", "color": GameState.cores["noé"]},
		{"name": "Noé (sussurro)", "text": "Era realmente amor, ou apenas medo de ficar sozinha?", "color": GameState.cores["noé"]},
		{"name": "Mãe (indignada)", "text": "É amor, tu é que és jovem demais para entender!", "color": GameState.cores["mãe"]},
		{"name": "Mãe (indignada)", "text": "Anda, fica comigo. Só eu sei cuidar de ti.", "color": GameState.cores["mãe"]},

	]

	# Diálogo final, que varia conforme as escolhas
	var dialogo_final := []

	if good_count > bad_count:
		dialogo_final = [
			{"name": "Noé (olhos erguidos)", "text": "Eu sei que me amaste, à tua maneira. E talvez isso tenha sido tudo o que podias dar.", "color": GameState.cores["noé"]},
			{"name": "Noé (olhos erguidos)", "text": "Amo-te, mas amar não é prender. Chegou o momento de viver... por mim.", "color": GameState.cores["noé"]},
			{"name": "Mãe (frustração)", "text": "Não... sem mim... tu vais...", "color": GameState.cores["mãe"]},
			{"name": "Noé (orgulho)", "text": "...cair. Mas logo me levanto. Assim é viver.", "color": GameState.cores["noé"]},
			{"name": "", "text": "[font_size=20](Até aqui a alma de Noé era muda como um túmulo, porém agora ia aprender a falar.)"},
		]
	else:
		dialogo_final = [
			{"name": "Noé (olhos baixos)", "text": "Talvez tenhas razão. Lá fora... não há lugar para mim.", "color": GameState.cores["noé"]},
			{"name": "Mãe (sorriso vitoriosa)", "text": "Vês como afinal compreendes? O mundo nunca te mereceu.", "color": GameState.cores["mãe"]},
			{"name": "Mãe (sorriso vitoriosa)", "text": "Só aqui estás seguro, só comigo és completo.", "color": GameState.cores["mãe"]},
			{"name": "", "text": "[font_size=20](Assim, a alma enchera-se-lhe de um silêncio perpétuo.)"},
		]

	# Junta os dois blocos e mostra numa só sequência
	var dialogo_completo = dialogo_inicial + dialogo_final

	GameState.show_dialog_sequence(dialogo_completo, false, "", "", self, "_on_final_dialog_finished")

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_play_choice_sound")).set_delay(0.1)
	tween.tween_callback(Callable(self, "_on_fade_to_black_complete"))

func _play_choice_sound():
	audio_player.play()

func _on_fade_to_black_complete():
	print_debug("Nó porta:", porta)
	print_debug("Nó porta_Area2D:", porta_Area2D)

	var porta_area = get_tree().get_current_scene().get_node_or_null("porta/Area2D")
	if porta_area and porta_area.has_method("ativar_interacao"):
		porta_area.ativar_interacao()
	else:
		print_debug("⚠ Porta não encontrada ou método ausente!")
	
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
	# Som
	audio_player.stream = preload("res://sounds/porta_abre.mp3")
	
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
