extends Node2D
class_name Weapon

signal attack_completed

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var damage_area : Area2D = $DamageArea

export var attack_power : int = 1

var _is_ready_for_combo : bool = false setget set_is_ready_for_combo
var _next_attack : Attack = null
var _previous_attack_list : String = ""

var _attack_data := {}
var _input_event_to_attack_list := {}

onready var character_sprite : Sprite
onready var weapon_sprite : Sprite = $Sprite


func _ready() -> void:
	yield(owner, "ready")
	character_sprite = owner.sprite
#	_validate_config()
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	damage_area.connect("body_entered", self, "_on_DamageArea_body_entered")


func _validate_config() -> void:
	for attack_list_index in len(_attack_data) - 1:
		assert(
			len(_attack_data.values()[attack_list_index])
			== len(_attack_data.values()[attack_list_index + 1]),
			"Weapon [%s] - Attack arrays must be the same length" % [name]
		)
	
	for attack_array in _attack_data.values():
		for attack in attack_array:
			if attack is Attack:
				# attack could be null
				assert(
					animation_player.has_animation(attack.anim_name),
					"Weapon [%s] missing animation [%s]" % [name, attack.anim_name]
				)
	
	for collision_shape in damage_area.get_children():
		assert(
			collision_shape is CollisionShape2D or collision_shape is CollisionPolygon2D,
			"Weapon [%s] has invalid children of [%s]" % [name, damage_area.name]
		)


func attack(attack_index : int = 0, attack_event : String = "attack_light") -> void:
	# Ignore method call if we are asked to perform a combo but are not ready
	if attack_index > 0 and not _is_ready_for_combo:
		return
	
	var attack_array : AttackArray
	var current_attack_list := ""
	
	# Determine which attack list we are using based on the input
	if attack_event in _input_event_to_attack_list:
		current_attack_list = _input_event_to_attack_list[attack_event]
	
	# Exit if we are not allowed to chain from the previous attack to the current attack
	if not _check_attack_chain_valid(_previous_attack_list, current_attack_list):
		return

	attack_array = _attack_data[current_attack_list]
	
	if attack_index >= attack_array.size():
		return
	if attack_array.get_attack(attack_index) == null:
		return
	
	_next_attack = attack_array.get_attack(attack_index)
	
	if attack_index == 0:
		_play_next_anim()
	
	_previous_attack_list = current_attack_list


func _check_attack_chain_valid(from: String, to: String) -> bool:
	# Always VALID if there is no previous attack
	if from == "":
		return true
	
	# If the attack data has no valid chains then the combo is INVALID
	if not "_chain" in _attack_data:
		return false
	
	# If the source attack is not in the chain list then INVALID
	if not from in _attack_data["_chain"]:
		return false
	
	# If the source attack exists in the chain list but is not allowed to chain to current then INVALID
	if not to in _attack_data["_chain"][from]:
		return false
	
	return true


func set_is_ready_for_combo(value : bool = true):
	_is_ready_for_combo = value


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "INIT":
		return
	
	if _next_attack:
		_play_next_anim()
	else:
		_cleanup()


func _play_next_anim() -> void:
	animation_player.play(
		_next_attack.anim_name,
		-1,
		_next_attack.play_speed
	)
	_next_attack = null


func _cleanup() -> void:
	_next_attack = null
	_is_ready_for_combo = false
	animation_player.play("INIT")
	_previous_attack_list = ""
	emit_signal("attack_completed")


func disable_all_attack_collisions() -> void:
	for collision_shape in damage_area.get_children():
		collision_shape.disabled = true


func _on_DamageArea_body_entered(_body: Node) -> void:
	pass
