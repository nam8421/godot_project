extends Node

func _ready():
	# 게임 시작 시 Title 씬으로 이동
	change_scene("res://scenes/Title.tscn")

func change_scene(path):
	# 기존 자식 노드 제거 (간단한 Scene 관리)
	for child in get_children():
		child.queue_free()
	
	var scene = load(path).instantiate()
	add_child(scene)
