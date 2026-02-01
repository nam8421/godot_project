extends Node

# 게임 전역 변수
var player_pokemon = null # Pokemon 객체
var wild_pokemon = null   # Pokemon 객체
var player_name = ""      # 플레이어 이름
var player_gender = ""    # 플레이어 성별 (Boy/Girl)
var battle_logs = []

var caught_pokemon = []
var seen_pokemon = []

func _ready():
	print("Global script loaded")

func set_start_pokemon(name):
	# Pokemon 클래스가 로드된 후 사용 가능
	# 여기서는 간단히 객체 생성
	var Pokemon = load("res://scripts/Pokemon.gd")
	player_pokemon = Pokemon.new(name, 5)
	seen_pokemon.append(player_pokemon.id)
	caught_pokemon.append(player_pokemon.id)
	print("Starter selected: ", player_pokemon.name)
