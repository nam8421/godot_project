extends Node2D

@onready var starter_selection_ui = $CanvasLayer/StarterSelection
@onready var dialog_label = $CanvasLayer/DialogLabel

func _ready():
	starter_selection_ui.visible = false
	dialog_label.visible = false
	
	$Buildings/OakNPC.interacted.connect(_on_oak_interacted)
	
	# 스타팅 포켓몬 버튼 연결
	$CanvasLayer/StarterSelection/BtnSquirtle.pressed.connect(func(): _on_starter_selected("꼬부기"))
	$CanvasLayer/StarterSelection/BtnCharmander.pressed.connect(func(): _on_starter_selected("파이리"))
	$CanvasLayer/StarterSelection/BtnBulbasaur.pressed.connect(func(): _on_starter_selected("이상해씨"))
	$CanvasLayer/StarterSelection/BtnPikachu.pressed.connect(func(): _on_starter_selected("피카츄"))

func _on_oak_interacted():
	if Global.player_pokemon == null:
		dialog_label.text = "오박사: 자, 여기서 자네의 파트너를 골라보게나."
		dialog_label.visible = true
		starter_selection_ui.visible = true
	else:
		dialog_label.text = "오박사: 자네의 포켓몬이 아주 건강해 보이는구만!"
		dialog_label.visible = true
		await get_tree().create_timer(2.0).timeout
		dialog_label.visible = false

func _on_starter_selected(pokemon_name):
	Global.set_start_pokemon(pokemon_name)
	starter_selection_ui.visible = false
	dialog_label.text = "오박사: " + pokemon_name + "(을)를 선택했군! 잘 부탁한다."
	await get_tree().create_timer(2.0).timeout
	dialog_label.visible = false
