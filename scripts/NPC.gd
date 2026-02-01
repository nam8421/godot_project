extends Area2D

signal interacted

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	if player_nearby and event.is_action_pressed("ui_accept"):
		interacted.emit()

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		# 힌트 UI 표시 가능 (예: "Press Space")

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false
