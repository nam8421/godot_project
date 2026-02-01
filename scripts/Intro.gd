extends Control

enum State { INTRO, GENDER_SELECT, NAME_INPUT, FINAL_ADVICE }

@onready var oak_image = $OakImage
@onready var dialog_label = $DialogPanel/DialogLabel
@onready var gender_selection = $CenterContainer/GenderSelection
@onready var name_input_container = $CenterContainer/NameInput
@onready var name_edit = $CenterContainer/NameInput/LineEdit
@onready var keyboard_grid = $CenterContainer/NameInput/KeyboardGrid

var current_state = State.INTRO
var intro_step = 0

func _ready():
	# UI 시그널 연결
	$CenterContainer/GenderSelection/BtnBoy.pressed.connect(_on_boy_pressed)
	$CenterContainer/GenderSelection/BtnGirl.pressed.connect(_on_girl_pressed)
	$CenterContainer/NameInput/BtnConfirm.pressed.connect(_on_name_confirm_pressed)
	
	# 가상 키보드 생성
	create_virtual_keyboard()

	# 초기 상태 설정
	gender_selection.visible = false
	name_input_container.visible = false
	oak_image.visible = true
	
	dialog_label.text = "반갑다! 나는 오박사라고 한단다.\n이 세계에는 포켓몬스터라고 불리는 생명체들이 살고 있지."
	current_state = State.INTRO

func _input(event):
	var accept_input = event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
	
	if accept_input:
		if current_state == State.INTRO:
			advance_intro()
		elif current_state == State.NAME_INPUT:
			if event.is_action_pressed("ui_accept"): # 이름 입력은 엔터만 허용 (클릭은 가상 키보드)
				_on_name_confirm_pressed()
		elif current_state == State.FINAL_ADVICE:
			start_game()

func start_game():
	print("Game Starting... Change scene to Explore.tscn")
	var err = get_tree().change_scene_to_file("res://scenes/Explore.tscn")
	if err != OK:
		print("Error changing scene: ", err)

func advance_intro():
	intro_step += 1
	if intro_step == 1:
		dialog_label.text = "사람들은 포켓몬과 친구가 되거나, 함께 승부를 하기도 하지."
	elif intro_step == 2:
		show_gender_selection()

func show_gender_selection():
	current_state = State.GENDER_SELECT
	oak_image.visible = false
	dialog_label.text = "너에 대해 알려주렴. 너는 남자니? 여자니?"
	gender_selection.visible = true

func _on_boy_pressed():
	Global.player_gender = "Boy"
	show_name_input()

func _on_girl_pressed():
	Global.player_gender = "Girl"
	show_name_input()

func show_name_input():
	current_state = State.NAME_INPUT
	gender_selection.visible = false
	oak_image.visible = false
	dialog_label.text = "그렇구나. 그럼 이름은 무엇이니? (아래 키보드로 입력)"
	name_input_container.visible = true
	name_edit.grab_focus()

func create_virtual_keyboard():
	# A-Z 버튼 생성
	var keys = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for character in keys:
		var btn = Button.new()
		btn.text = character
		btn.custom_minimum_size = Vector2(40, 40)
		btn.focus_mode = Control.FOCUS_NONE # 포커스 뺏기 방지
		btn.pressed.connect(func(): _on_key_pressed(character))
		keyboard_grid.add_child(btn)
	
	# 특수 키 (Backspace, Clear)
	var btn_del = Button.new()
	btn_del.text = "DEL"
	btn_del.custom_minimum_size = Vector2(40, 40)
	btn_del.focus_mode = Control.FOCUS_NONE
	btn_del.pressed.connect(func(): _on_key_pressed("DEL"))
	keyboard_grid.add_child(btn_del)

	var btn_ok = Button.new()
	btn_ok.text = "OK"
	btn_ok.custom_minimum_size = Vector2(40, 40)
	btn_ok.focus_mode = Control.FOCUS_NONE
	btn_ok.pressed.connect(_on_name_confirm_pressed)
	keyboard_grid.add_child(btn_ok)

func _on_key_pressed(key):
	if key == "DEL":
		var text = name_edit.text
		if text.length() > 0:
			name_edit.text = text.substr(0, text.length() - 1)
	else:
		if name_edit.text.length() < name_edit.max_length:
			name_edit.text += key
	
	name_edit.caret_column = name_edit.text.length()

func _on_name_confirm_pressed():
	if name_edit.text.strip_edges() == "":
		dialog_label.text = "이름을 입력해야 한다!"
		return
		
	Global.player_name = name_edit.text
	show_final_advice()

func show_final_advice():
	current_state = State.FINAL_ADVICE
	name_input_container.visible = false
	
	# 안전하게 포커스 해제 (버튼이 스페이스바 가로채기 방지)
	var focus_owner = get_viewport().gui_get_focus_owner()
	if focus_owner:
		focus_owner.release_focus()
	
	# 오박사 다시 등장
	oak_image.visible = true
	
	dialog_label.text = "아하! 너의 이름은 " + Global.player_name + " 이구나!\n이제 너만의 포켓몬 전설이 시작되려 한다!\n꿈과 모험의 세계로! 레츠 고!"
