extends CharacterBody2D

const SPEED = 150.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer # 만약 애니메이션을 쓴다면

func _ready():
	# 성별에 따라 스프라이트 텍스처 로드
	if Global.player_gender == "Girl":
		sprite.texture = load("res://assets/girl_walk.png")
	else:
		sprite.texture = load("res://assets/boy_walk.png")
		
	# 스프라이트 시트 설정 (간단히 프레임으로 처리하거나 AnimationPlayer 사용)
	# 여기서는 간단히 텍스처만 입힘. 애니메이션은 추후 고도화 가능.
	sprite.hframes = 4 # 가정: 가로 4프레임
	sprite.vframes = 4 # 가정: 세로 4프레임 (Idle, Down, Up, Side)

func _physics_process(delta):
	# 입력 처리
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
		
		# 방향에 따른 프레임 변경 (간단 구현)
		if direction.x > 0:
			sprite.frame_coords.y = 3 # Right (가정)
			sprite.flip_h = false
		elif direction.x < 0:
			sprite.frame_coords.y = 3 # Left (좌우 반전 사용)
			sprite.flip_h = true
		elif direction.y > 0:
			sprite.frame_coords.y = 1 # Down
		elif direction.y < 0:
			sprite.frame_coords.y = 2 # Up
			
		# 걷는 애니메이션 (프레임 순환)
		sprite.frame_coords.x = int(Time.get_ticks_msec() / 200) % 4
	else:
		velocity = Vector2.ZERO
		sprite.frame_coords.x = 0 # 정지 프레임

	move_and_slide()
