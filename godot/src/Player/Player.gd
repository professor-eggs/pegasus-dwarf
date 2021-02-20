extends KinematicBody2D
class_name Player

# Baddies are called Steel (big knight with cape) and Gorgon (big guy with mask)


onready var state_machine : StateMachine = $StateMachine
onready var sprite : Sprite = $CharacterPivot/Sprite
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var weapon_animation_player : AnimationPlayer = $WeaponAnimationPlayer
onready var camera : Camera2D = $Camera2D
onready var combat_actions : Node2D = $CombatActions
onready var weapon_pivot : Position2D = $WeaponPivot
onready var weapon : KinematicBody2D = $WeaponPivot/Weapon

var attack_global_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	for child in combat_actions.get_children():
		if child is CombatActionCombo:
			child.setup(weapon_animation_player)
			child.connect("exited", self, "_on_CombatActionCombo_exited")


func get_input_direction() -> Vector2:
	var dir := Vector2.ZERO
	dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return dir.normalized()


func get_angle_to_mouse() -> float:
	var mouse_position := get_global_mouse_position()
	var dir := mouse_position - global_position
	return global_position.angle_to(dir)


func turn_to_face_mouse_position(mouse_global_position : Vector2) -> void:
	if mouse_global_position.x == global_position.x:
		return
	sprite.scale.x = sign(mouse_global_position.x - global_position.x) * abs(sprite.scale.x)


func _on_StateMachine_transitioned(_state_name : String) -> void:
	return
#	print("Transitioned to ", state_name)


func _on_CombatActionCombo_exited(exit_code) -> void:
	match exit_code:
		CombatAction.ExitCodes.ACTION_COMPLETED:
			weapon_animation_player.play("INIT")
