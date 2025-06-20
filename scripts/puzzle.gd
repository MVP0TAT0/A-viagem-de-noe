extends Node2D

var selected_index := 0
var joias := []
var tween: Tween
var posicoes_originais := []

enum Estado { SELECIONAR_JOIA, MOVER_JOIA }
var estado := Estado.SELECIONAR_JOIA

var lugares := []
var lugar_para_joia := []
var ocupacoes := []
var fixadas := []
var indice_para_numero_joia := []

# Sons
@onready var som_colar = $SomColar
@onready var som_pin = $SomPin
@onready var som_brincos = $SomBrincos
@onready var som_pulseira = $SomPulseira

func _ready():
	$Caixa.visible = false

	var ordem_desorganizada := [
		2, 10, 12, 18, 13, 5, 8, 7, 11, 19,
		20, 1, 3, 6, 15, 4, 14, 16, 9, 17
	]

	for i in ordem_desorganizada:
		var joia = $Caixa.get_node("Joia" + str(i))
		joia.set_meta("pos_inicial", joia.global_position)
		joias.append(joia)
		posicoes_originais.append(joia.position)
		indice_para_numero_joia.append(i)
		fixadas.append(false)

	for i in 20:
		var lugar = $Caixa.get_node("Lugar" + str(i + 1))
		lugares.append(lugar)
		lugar_para_joia.append(i)
		ocupacoes.append(-1)

	_animar_joia(selected_index)

func mostrar_caixa():
	$Caixa.visible = true

func _process(delta):
	if estado == Estado.SELECIONAR_JOIA:
		if Input.is_action_just_pressed("ui_left"): _mudar_selecao(-1)
		if Input.is_action_just_pressed("ui_right"): _mudar_selecao(1)
		if Input.is_action_just_pressed("interact"): _tentar_mover_para_lugar()
	elif estado == Estado.MOVER_JOIA:
		if Input.is_action_just_pressed("ui_left"): _mover_entre_lugares(-1)
		if Input.is_action_just_pressed("ui_right"): _mover_entre_lugares(1)
		if Input.is_action_just_pressed("interact"): _validar_ou_reverter()

func _mudar_selecao(direcao: int):
	_parar_animacao()

	if selected_index < joias.size() and not fixadas[selected_index]:
		joias[selected_index].position.y = posicoes_originais[selected_index].y

	var nova_index = selected_index
	var tentativas = 0
	while tentativas < joias.size():
		nova_index = wrapi(nova_index + direcao, 0, joias.size())
		if not fixadas[nova_index]:
			selected_index = nova_index
			_animar_joia(selected_index)
			return
		tentativas += 1

func _animar_joia(index: int):
	var joia = joias[index]
	var pos_y_base: float
	var esta_num_lugar := false
	for i in ocupacoes.size():
		if ocupacoes[i] == index:
			pos_y_base = joia.position.y
			esta_num_lugar = true
			break

	if not esta_num_lugar:
		pos_y_base = posicoes_originais[index].y

	tween = create_tween()
	tween.set_loops()
	tween.tween_property(joia, "position:y", pos_y_base - 10, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(joia, "position:y", pos_y_base, 0.2).set_delay(0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _parar_animacao():
	if tween:
		tween.kill()

var lugar_index := 0

func _tentar_mover_para_lugar():
	_parar_animacao()
	for i in ocupacoes.size():
		if ocupacoes[i] == -1:
			lugar_index = i
			ocupacoes[i] = selected_index
			joias[selected_index].position = lugares[i].position
			estado = Estado.MOVER_JOIA
			return

func _mover_entre_lugares(direcao: int):
	var joia = joias[selected_index]
	ocupacoes[lugar_index] = -1
	var novo_index = lugar_index
	while true:
		novo_index = wrapi(novo_index + direcao, 0, lugares.size())
		if ocupacoes[novo_index] == -1:
			break
	lugar_index = novo_index
	ocupacoes[lugar_index] = selected_index
	joia.position = lugares[lugar_index].position

func _validar_ou_reverter():
	if lugar_index + 1 == indice_para_numero_joia[selected_index]:
		fixadas[selected_index] = true

		var numero_joia = indice_para_numero_joia[selected_index]
		var som = _som_para_joia(numero_joia)
		if som:
			som.play()

		estado = Estado.SELECIONAR_JOIA
		_check_puzzle_completo()
		_mudar_selecao(1)
	else:
		var joia = joias[selected_index]
		joia.position = _posicao_inicial_da_joia(selected_index)
		ocupacoes[lugar_index] = -1
		estado = Estado.SELECIONAR_JOIA

func _som_para_joia(numero_joia: int) -> AudioStreamPlayer2D:
	match numero_joia:
		1:
			return som_colar
		11, 12, 13, 14:
			return som_pin
		2, 3, 4, 5, 6, 7, 8, 9, 10:
			return som_brincos
		15, 16, 17, 18, 19, 20:
			return som_pulseira
		_:
			return null  # garante retorno para qualquer outro número


func _check_puzzle_completo():
	for i in ocupacoes.size():
		var index_da_joia_colocada = ocupacoes[i]
		if index_da_joia_colocada == -1:
			return
		var numero_da_joia_colocada = indice_para_numero_joia[index_da_joia_colocada]
		if numero_da_joia_colocada != i + 1:
			return
	GameState.puzzle_joias_completo = true
	GameState.show_dialog_sequence([
		{"name": "Noé", "text": "Perfeito... agora tudo encaixa.", "color": GameState.cores["noé"]}
	], false, "", "", self, "_fechar_depois_de_dialogo")

func _fechar_depois_de_dialogo():
	fechar_puzzle()

func _posicao_inicial_da_joia(index: int) -> Vector2:
	return posicoes_originais[index]

func fechar_puzzle():
	queue_free()
	GameState.movement_locked = false
	GameState.interaction_locked = false
