"""
Conditions:
	Any directional input


Effects:
	Accelerate to max speed in the provided direction


Valid transitions:
	IDLE:
		No directional input
		No attacking input
		Velocity is zero
	
	ATTACK:
		On attacking input

"""

extends PlayerState


var agent : GSAIKinematicBody2DAgent
var target : GSAIAgentLocation
var arrive : GSAIArrive
var _accel : GSAITargetAcceleration

var _drag := 0.1

export var linear_speed_max := 100
export var linear_acceleration_max := 500
var _arrival_tolerance := 24.0
var _deceleration_radius := 4.0
var _target_distance := 32.0


func _ready() -> void:
	yield(owner, "ready")
	_setup_steering()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_light"):
		state_machine.transition_to("Attack", {"attack_event" : "attack_light"})
	
	if event.is_action_pressed("attack_heavy"):
		state_machine.transition_to("Attack", {"attack_event" : "attack_heavy"})


func physics_update(delta: float) -> void:
	player.animation_player.play("run")
	var input_direction := player.get_input_direction()
	if input_direction == Vector2.ZERO:
		if agent.linear_velocity.distance_to(Vector3.ZERO) <= _arrival_tolerance:
			state_machine.transition_to("Idle")
	
	var mouse_global_position := player.get_global_mouse_position()
	player.aim_weapon_at_mouse_position(mouse_global_position)
	player.turn_to_face_mouse_position(mouse_global_position)
	
	target.position = GSAIUtils.to_vector3((_target_distance * player.get_input_direction()) + player.global_position)
	arrive.calculate_steering(_accel)
	agent._apply_steering(_accel, delta)


func _setup_steering() -> void:
	agent = GSAIKinematicBody2DAgent.new(owner)
	target = GSAIAgentLocation.new()
	arrive = GSAIArrive.new(agent, target)
	_accel = GSAITargetAcceleration.new()
	
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = _drag
	arrive.deceleration_radius = _deceleration_radius
	arrive.arrival_tolerance = _arrival_tolerance
	target.position = agent.position


func _set_target_position(target_position : Vector2) -> void:
	target.position = GSAIUtils.to_vector3(target_position)


func _get_target_position() -> Vector2:
	return GSAIUtils.to_vector2(target.position)


func _turn_to_face_movement_direction(input_direction : Vector2) -> void:
	player.sprite.scale.x = sign(input_direction.x) * 1 if input_direction.x != 0 else player.sprite.scale.x

