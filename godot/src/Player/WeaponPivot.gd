extends KinematicBody2D

export var _max_distance_from_player_x : float = 16
export var _max_distance_from_player_y : float = 6

var agent : GSAIKinematicBody2DAgent
var target : GSAIAgentLocation
var arrive : GSAIArrive
var _accel : GSAITargetAcceleration

var _drag := 0.1

export var linear_speed_max := 200
export var linear_acceleration_max := 600
var _arrival_tolerance := 4.0
var _deceleration_radius := 8.0


func _ready() -> void:
	_setup_steering()


func _physics_process(delta: float) -> void:
	var target_local_position : Vector2 = owner.get_local_mouse_position().clamped(_max_distance_from_player_x)
	target_local_position.y = clamp(target_local_position.y, -_max_distance_from_player_y, _max_distance_from_player_y)
	
	var target_global_position : Vector2 = owner.to_global(target_local_position)
	
	_set_target_position(target_global_position)
	
	arrive.calculate_steering(_accel)
	agent._apply_steering(_accel, delta)


func _setup_steering() -> void:
	agent = GSAIKinematicBody2DAgent.new(self)
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
