extends Node
class_name CombatAction

enum ExitCodes { ACTION_COMPLETED, COMBO_CHAIN, ACTION_INTERRUPTED }

signal exited(exit_code)

onready var _path_to_self := owner.get_path_to(self)

var _combo_event_actions := {}
var _active_child_combat_action = null
var _is_active := false

var animation_player : AnimationPlayer setget _set_animation_player


func _ready() -> void:
	_get_combo_event_actions()


func enter(_msg := {}) -> void:
	pass


func exit(exit_code : int = ExitCodes.ACTION_COMPLETED) -> void:
	emit_signal("exited", exit_code)


func _unhandled_input(event: InputEvent) -> void:
	if not _is_active:
		return
	
	for action in _combo_event_actions:
		if event.is_action_pressed(action):
			_is_active = false
			_active_child_combat_action = _combo_event_actions[action]
			var _err : int = _active_child_combat_action.connect(
				"exited",
				self,
				"_on_active_child_combat_action_exited"
			)
			_active_child_combat_action.enter()
			exit(ExitCodes.COMBO_CHAIN)


func _on_active_child_combat_action_exited(exit_code : int):
	match exit_code:
		ExitCodes.ACTION_COMPLETED:
			_is_active = true
			_active_child_combat_action.disconnect(
				"exited",
				self,
				"_on_active_child_combat_action_exited"
			)
			_active_child_combat_action = null
			exit(ExitCodes.ACTION_COMPLETED)
		
		ExitCodes.COMBO_CHAIN:
			pass
		
		ExitCodes.ACTION_INTERRUPTED:
			pass


func _set_animation_player(value) -> void:
	animation_player = value
	for child in get_children():
		child.animation_player = animation_player


func _get_combo_event_actions() -> void:
	for child in get_children():
		if not child.event_action in _combo_event_actions:
			# if not child is CombatActionAttack:
			if not child.get("event_action"):
				continue
			_combo_event_actions[child.event_action] = child
	
