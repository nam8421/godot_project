extends Control

@onready var container = $ScrollContainer/VBoxContainer
@onready var label_page = $LabelPage
const ITEMS_PER_PAGE = 50 # 스크롤이 되므로 한 번에 많이 로드해도 됨

func _ready():
	_load_list()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()

func _load_list():
	# 기존 아이템 제거
	for child in container.get_children():
		child.queue_free()
	
	# ID 순 정렬
	var pokes = []
	for key in PokemonData.POKEMON_DATA:
		pokes.append(PokemonData.POKEMON_DATA[key])
	
	pokes.sort_custom(func(a, b): return a["id"] < b["id"])
	
	for data in pokes:
		var hbox = HBoxContainer.new()
		
		# ID
		var lbl_id = Label.new()
		lbl_id.text = "No.%03d" % data["id"]
		lbl_id.custom_minimum_size.x = 80
		hbox.add_child(lbl_id)
		
		# Image
		var tex = TextureRect.new()
		tex.custom_minimum_size = Vector2(40, 40)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var path = "res://assets/%d.png" % data["id"]
		if FileAccess.file_exists(path):
			tex.texture = load(path)
		hbox.add_child(tex)
		
		# Name
		var lbl_name = Label.new()
		lbl_name.text = "   " + data.get("name_kr", "???") # data.py 키가 한글 이름임
		# data.py 구조: "이상해씨": {id:1...} -> key가 이름
		# PokemonData.POKEMON_DATA 구조가 { "이상해씨": {...} } 이므로
		# 위 루프에서 key를 알 수 없게 짰음. 수정 필요.
		hbox.add_child(lbl_name)
		
		container.add_child(hbox)
	
	# 이름 표시 수정
	# 위 루프를 다시 짬
	pass

func _load_list_correct():
	for child in container.get_children():
		child.queue_free()

	# Key-Value 쌍을 리스트로 변환
	var items = []
	for name in PokemonData.POKEMON_DATA:
		var data = PokemonData.POKEMON_DATA[name]
		items.append({"name": name, "data": data})
	
	items.sort_custom(func(a, b): return a["data"]["id"] < b["data"]["id"])
	
	for item in items:
		var name = item["name"]
		var data = item["data"]
		
		var hbox = HBoxContainer.new()
		
		# ID
		var lbl_id = Label.new()
		lbl_id.text = "No.%03d" % data["id"]
		lbl_id.custom_minimum_size.x = 100
		lbl_id.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl_id.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(lbl_id)
		
		# Image
		var tex = TextureRect.new()
		tex.custom_minimum_size = Vector2(50, 50)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		var path = "res://assets/%d.png" % data["id"]
		if FileAccess.file_exists(path):
			tex.texture = load(path)
		hbox.add_child(tex)
		
		# Name
		var lbl_name = Label.new()
		lbl_name.text = "   " + name
		lbl_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(lbl_name)
		
		# Type
		var lbl_type = Label.new()
		lbl_type.text = "   [" + data["type"] + "]"
		lbl_type.modulate = Color(0.7, 0.7, 0.7)
		lbl_type.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hbox.add_child(lbl_type)
		
		container.add_child(hbox)

func _ready_override():
	_load_list_correct()
	$BtnBack.pressed.connect(_on_back_pressed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/Explore.tscn")
