class_name Pokemon extends RefCounted

var name: String
var id: int
var type: String
var max_hp: int
var current_hp: int
var attack_stat: int
var defense_stat: int
var moves: Array
var level: int

func _init(p_name: String, p_level: int):
	self.name = p_name
	self.level = p_level
	
	var data = PokemonData.POKEMON_DATA.get(name)
	if data:
		self.id = data["id"]
		self.type = data["type"]
		# 레벨에 따른 스탯 계산 (간단화)
		self.max_hp = int(data["hp"] * (1 + level * 0.1))
		self.current_hp = self.max_hp
		self.attack_stat = int(data["attack"] * (1 + level * 0.1))
		self.defense_stat = int(data["defense"] * (1 + level * 0.1))
		self.moves = data["moves"]
	else:
		printerr("Unknown pokemon: ", name)

func heal():
	current_hp = max_hp

func is_fainted() -> bool:
	return current_hp <= 0

func take_damage(damage: int):
	current_hp = max(0, current_hp - damage)

func attack(target, move_name) -> Array:
	# Returns [success, logs]
	# Python: return success, logs
	# GDScript: return [bool, Array]
	
	var logs = []
	var move_data = PokemonData.MOVES.get(move_name)
	
	if not move_data:
		logs.append(name + "의 " + move_name + "!")
		logs.append("하지만 기술을 사용할 수 없다!")
		return [false, logs]
		
	logs.append(name + "의 " + move_name + "!")
	
	# 명중률 확인
	if randi() % 100 >= move_data["accuracy"]:
		logs.append("그러나 공격은 빗나갔다!")
		return [false, logs]
		
	# 데미지 계산
	var type_multiplier = PokemonData.get_type_effectiveness(move_data["type"], target.type)
	
	if move_data["power"] == 0:
		# 보조 기술
		if "effect" in move_data:
			# 구현 생략 (버프/디버프)
			logs.append("효과가 있었...나?")
		return [true, logs]
		
	# 물리 데미지 공식 (간소화)
	# Damage = (((2*Level/5 + 2) * Power * A / D) / 50 + 2) * Modifier
	
	var ad_ratio = float(attack_stat) / float(target.defense_stat)
	var base_damage = (((2.0 * level / 5.0 + 2.0) * move_data["power"] * ad_ratio) / 50.0 + 2.0)
	
	# 랜덤 (0.85 ~ 1.0)
	var random_mod = randf_range(0.85, 1.0)
	
	# 자속 보정 (STAB)
	var stab = 1.0
	if move_data["type"] == type:
		stab = 1.5
		
	var damage = int(base_damage * type_multiplier * stab * random_mod)
	if damage < 1: damage = 1
	
	target.take_damage(damage)
	
	if type_multiplier > 1.0:
		logs.append("효과가 굉장했다!")
	elif type_multiplier < 1.0 and type_multiplier > 0:
		logs.append("효과가 별로인 듯하다...")
	elif type_multiplier == 0:
		logs.append("효과가 없다...")
		
	if randf() < 0.125: # 급소 (1/8 확률)
		damage = int(damage * 1.5)
		logs.append("급소에 맞았다!")
		
	logs.append(str(damage) + "의 데미지를 입혔다!")
	
	return [true, logs]

static func create_wild(level_min, level_max) -> Pokemon:
	# 랜덤 포켓몬 생성
	var names = PokemonData.POKEMON_DATA.keys()
	var random_name = names[randi() % names.size()]
	var random_level = randi_range(level_min, level_max)
	
	var p = load("res://scripts/Pokemon.gd").new(random_name, random_level)
	return p
