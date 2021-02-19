extends KinematicBody2D
class_name Player

# Baddies are called Steel (big knight with cape) and Gorgon (big guy with mask)


onready var state_machine : StateMachine = $StateMachine
onready var sprite : Sprite = $Pivot/Sprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var camera : Camera2D = $Camera2D
onready var weapon_pivot : Position2D = $Pivot/WeaponPivot
onready var weapon : Weapon = weapon_pivot.get_child(0)


func _ready() -> void:
	weapon.connect("attack_completed", self, "_on_Weapon_attack_completed")


func get_input_direction() -> Vector2:
	var dir := Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return dir.normalized()


func turn_to_face_mouse_position(mouse_global_position : Vector2) -> void:
	if mouse_global_position.x == global_position.x:
		return
	sprite.scale.x = sign(mouse_global_position.x - global_position.x) * abs(sprite.scale.x)


func aim_weapon_at_mouse_position(mouse_global_position : Vector2) -> void:
	if mouse_global_position == global_position:
		return
	weapon_pivot.rotation = (mouse_global_position - global_position).angle()


func _on_StateMachine_transitioned(state_name : String) -> void:
	print("Transitioned to ", state_name)


func _on_Weapon_attack_completed() -> void:
	get_node("StateMachine/Attack").on_Player_attack_completed()


func set_rotation(value):
	print('rotation')


func set_rotation_degrees(value):
	print('degrees')
