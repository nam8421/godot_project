extends Control

func _ready():
	# 시그널 연결은 에디터에서 하거나 코드로 가능
	# 여기선 코드로 예시
	$VBoxContainer/BtnSquirtle.pressed.connect(func(): _on_start_game("꼬부기"))
	$VBoxContainer/BtnCharmander.pressed.connect(func(): _on_start_game("파이리"))
	$VBoxContainer/BtnBulbasaur.pressed.connect(func(): _on_start_game("이상해씨"))
	$VBoxContainer/BtnPikachu.pressed.connect(func(): _on_start_game("피카츄"))

func _on_start_game(pokemon_name):
	Global.set_start_pokemon(pokemon_name)
	# 씬 전환 (Main 노드를 찾아서 호출하거나 get_tree 사용)
	# 여기서는 간단히 get_tree().change_scene_to_file 사용 (Global과는 별개로 Root 교체 방식)
	# 하지만 Main.gd가 root라면 Main 함수 호출이 나음. 
	# Godot 4에서는 change_scene_to_file이 권장됨.
	get_tree().change_scene_to_file("res://scenes/Explore.tscn")
