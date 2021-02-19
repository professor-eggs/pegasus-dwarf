extends Resource
class_name AttackArray

var attacks := [] setget _set_attacks


func _init(attacks : Array) -> void:
	for attack_index in len(attacks):
		assert(
			attacks[attack_index] == null or attacks[attack_index] is Attack,
			"Attack index [%d] is invalid" % [attack_index]
		)
	
	self.attacks = attacks


func get_attack(index : int) -> Attack:
	return attacks[index]


func append_attack(attack : Attack) -> void:
	attacks.append(attack)


func insert_attack(index : int, attack : Attack) -> void:
	attacks.insert(index, attack)


func random_attack() -> Attack:
	var index := randi() % len(attacks)
	return attacks[index]


func _set_attacks(value) -> void:
	for attack_index in len(value):
		assert(
			value[attack_index] == null or value[attack_index] is Attack,
			"Attack index [%d] is invalid" % [attack_index]
		)
	
	attacks = value


func size() -> int:
	return attacks.size()
