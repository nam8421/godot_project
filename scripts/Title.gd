extends Control

func _ready():
	# 게임 시작 버튼 연결
	$VBoxContainer/BtnStart.pressed.connect(_on_start_pressed)
	$VBoxContainer/BtnStart.grab_focus()

func _on_start_pressed():
	# 인트로 씬으로 전환
	get_tree().change_scene_to_file("res://scenes/Intro.tscn")
