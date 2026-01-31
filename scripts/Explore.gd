extends Control

@onready var label_info = $LabelInfo
@onready var texture_player = $TexturePlayer

func _ready():
	# UI 업데이트
	update_ui()
	
	# 버튼 연결
	$VBoxContainer/BtnBattle.pressed.connect(_on_battle_pressed)
	$VBoxContainer/BtnHeal.pressed.connect(_on_heal_pressed)
	$VBoxContainer/BtnPokedex.pressed.connect(_on_pokedex_pressed)
	$VBoxContainer/BtnQuit.pressed.connect(_on_quit_pressed)

func update_ui():
	if Global.player_pokemon:
		label_info.text = "파트너: %s (Lv.%d)" % [Global.player_pokemon.name, Global.player_pokemon.level]
		var path = "res://assets/%d.png" % Global.player_pokemon.id
		if FileAccess.file_exists(path):
			texture_player.texture = load(path)

func _on_battle_pressed():
	# 배틀 씬으로 전환
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_heal_pressed():
	if Global.player_pokemon:
		Global.player_pokemon.heal()
		print("포켓몬이 회복되었습니다.")

func _on_pokedex_pressed():
	get_tree().change_scene_to_file("res://scenes/Pokedex.tscn")

func _on_quit_pressed():
	get_tree().quit()
