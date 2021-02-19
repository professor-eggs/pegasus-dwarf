extends Node2D
class_name CombatActionAttack

signal started
signal interrupted(interruption)
signal completed


export var _action_name : String
export var _input_event : String
export var _is_interrupted_by_hit : bool = true
export var _is_interrupted_by_combo : bool = false
export var _perform_completed_if_interrupted : bool = false
export var _lag_startup_msec : float = 0.0
export var _lag_cooldown_msec : float = 0.0
export var _animation_speed : float = 1.0

var _weapon : Weapon = null
var _start_time_msec : float = 0.0
var _end_time_msec : float = 0.0
var _duration_msec : float = 0.0

onready var character_remote_transform : RemoteTransform2D = $CharacterRemoteTransform2D
onready var weapon_remote_transform : RemoteTransform2D = $WeaponRemoteTransform
onready var combo_actions : Node2D = $ComboActions
onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if owner is Weapon:
		yield(owner, "ready")
		_weapon = owner
		$Placeholders.queue_free()
		character_remote_transform.remote_path = character_remote_transform.get_path_to(_weapon.character_sprite)
		weapon_remote_transform.remote_path = weapon_remote_transform.get_path_to(_weapon.weapon_sprite)
		animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")


func start() -> void:
	_start_time_msec = OS.get_system_time_msecs()
	emit_signal("started")
	yield(get_tree().create_timer(_lag_startup_msec), "timeout")
	if animation_player.has_animation("Start"):
		animation_player.play("Start")


func interrupt(interruption : CombatActionInterruption) -> void:
	emit_signal("interrupted", interruption)
	
	if animation_player.has_animation("INIT"):
		animation_player.play("INIT")
	
	if _perform_completed_if_interrupted:
		completed()


func completed() -> void:
	emit_signal("completed")


func _calculate_duration_msec() -> float:
	var _end_time_msec = OS.get_system_time_msecs()
	_duration_msec = _end_time_msec - _start_time_msec
	return _duration_msec


func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	match anim_name:
		"Start":
			yield(get_tree().create_timer(_lag_cooldown_msec / 1000), "timeout")
			completed()
