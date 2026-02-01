extends Control

@onready var text_wild_name = $PanelTop/LabelName
@onready var text_player_name = $PanelBottom/LabelName
@onready var bar_wild_hp = $PanelTop/ProgressBar
@onready var bar_player_hp = $PanelBottom/ProgressBar
@onready var logs = $PanelLog/RichTextLabel

@onready var tex_wild = $PanelTop/TextureRect
@onready var tex_player = $PanelBottom/TextureRect

var menu_state = "MAIN" # MAIN, FIGHT, RESULT

func _ready():
	# 야생 포켓몬 생성
	Global.wild_pokemon = load("res://scripts/Pokemon.gd").create_wild(Global.player_pokemon.level - 1, Global.player_pokemon.level + 1)
	Global.seen_pokemon.append(Global.wild_pokemon.id)
	
	add_log("야생의 " + Global.wild_pokemon.name + "가 나타났다!")
	
	update_ui()
	
	# 버튼 연결
	$PanelMenu/HBoxMain/BtnFight.pressed.connect(_on_fight_menu)
	$PanelMenu/HBoxMain/BtnCatch.pressed.connect(_on_catch)
	$PanelMenu/HBoxMain/BtnRun.pressed.connect(_on_run)
	
	$PanelMenu/HBoxFight/BtnBack.pressed.connect(_on_back)
	
	# 기술 버튼 (동적 할당 필요하지만 여기선 고정 4개 예시)
	for i in range(4):
		var btn = get_node("PanelMenu/HBoxFight/GridContainer/BtnMove" + str(i+1))
		btn.pressed.connect(func(): _on_move_pressed(i))

	# 초기 포커스
	$PanelMenu/HBoxMain/BtnFight.grab_focus()

func _input(event):
	if menu_state == "FIGHT" and event.is_action_pressed("ui_cancel"):
		_on_back()

func update_ui():
	# Wild
	text_wild_name.text = "Wild " + Global.wild_pokemon.name + " Lv." + str(Global.wild_pokemon.level)
	bar_wild_hp.max_value = Global.wild_pokemon.max_hp
	bar_wild_hp.value = Global.wild_pokemon.current_hp
	
	var path_wild = "res://assets/%d.png" % Global.wild_pokemon.id
	if FileAccess.file_exists(path_wild):
		tex_wild.texture = load(path_wild)
	
	# Player
	text_player_name.text = Global.player_pokemon.name + " Lv." + str(Global.player_pokemon.level)
	bar_player_hp.max_value = Global.player_pokemon.max_hp
	bar_player_hp.value = Global.player_pokemon.current_hp
	
	var path_player = "res://assets/%d.png" % Global.player_pokemon.id
	if FileAccess.file_exists(path_player):
		tex_player.texture = load(path_player)
		tex_player.flip_h = true # 뒷모습 대신 좌우반전
		
	# Moves
	if menu_state == "FIGHT":
		$PanelMenu/HBoxMain.visible = false
		$PanelMenu/HBoxFight.visible = true
		for i in range(4):
			var btn = get_node("PanelMenu/HBoxFight/GridContainer/BtnMove" + str(i+1))
			if i < Global.player_pokemon.moves.size():
				btn.text = Global.player_pokemon.moves[i]
				btn.disabled = false
			else:
				btn.text = "-"
				btn.disabled = true
		
		# 첫 번째 유효한 기술 버튼에 포커스
		var first_move_btn = get_node("PanelMenu/HBoxFight/GridContainer/BtnMove1")
		if first_move_btn and not first_move_btn.disabled:
			first_move_btn.grab_focus()
	else:
		$PanelMenu/HBoxMain.visible = true
		$PanelMenu/HBoxFight.visible = false
		
		# 메인 메뉴로 돌아오면 싸우다 버튼 포커스
		$PanelMenu/HBoxMain/BtnFight.grab_focus()

func add_log(text):
	logs.text += text + "\n"
	# 스크롤 자동 이동 (Godot 4)
	logs.scroll_to_line(logs.get_line_count())

func _on_fight_menu():
	menu_state = "FIGHT"
	update_ui()

func _on_back():
	menu_state = "MAIN"
	update_ui()

func _on_move_pressed(idx):
	var move_name = Global.player_pokemon.moves[idx]
	var result = Global.player_pokemon.attack(Global.wild_pokemon, move_name)
	# Logs
	for l in result[1]: add_log(l)
	
	update_ui()
	
	if Global.wild_pokemon.is_fainted():
		add_log("이겼다!")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/Explore.tscn")
		return

	# Enemy Turn
	enemy_turn()

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	# 간단 AI: 랜덤 기술
	var moves = Global.wild_pokemon.moves
	var move = moves[randi() % moves.size()]
	var result = Global.wild_pokemon.attack(Global.player_pokemon, move)
	
	for l in result[1]: add_log(l)
	update_ui()
	
	if Global.player_pokemon.is_fainted():
		add_log("지... 졌다...")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/Explore.tscn")

func _on_catch():
	add_log("몬스터볼을 던졌다!")
	var chance = 0.5 # 50%
	if randf() < chance:
		add_log("잡았다!")
		if not Global.caught_pokemon.has(Global.wild_pokemon.id):
			Global.caught_pokemon.append(Global.wild_pokemon.id)
			
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/Explore.tscn")
	else:
		add_log("튀어나왔다!")
		enemy_turn()

func _on_run():
	add_log("도망쳤다!")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/Explore.tscn")
