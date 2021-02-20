extends CombatAction
class_name CombatActionAttack


export (String, "attack_light", "attack_heavy") var event_action : String = "attack_light"
export var _animation_play_speed_secs : float = 1.0
export var _animation_name := ""


func _ready() -> void:
	if not _animation_name:
		_animation_name = name


func enter(_msg := {}) -> void:
	_is_active = true
	print("entered ", _path_to_self)
	var anim : Animation = animation_player.get_animation(_animation_name)
	var factor =  anim.length / _animation_play_speed_secs
	animation_player.play(_animation_name, -1, factor)
	var _err := animation_player.connect("animation_finished", self, "_on_animation_player_animation_finished")


func exit(exit_code : int = ExitCodes.ACTION_COMPLETED) -> void:
	print("exited ", _path_to_self, " with exit code ", ExitCodes.keys()[exit_code])
	
	match exit_code:
		ExitCodes.ACTION_COMPLETED:
			animation_player.disconnect("animation_finished", self, "_on_animation_player_animation_finished")
		
		ExitCodes.COMBO_CHAIN:
			pass
		
		ExitCodes.ACTION_INTERRUPTED:
			pass

	emit_signal("exited", exit_code)
	_is_active = false


func _on_animation_player_animation_finished(anim_name : String) -> void:
	if anim_name == "INIT":
		return

	print(_path_to_self, " animation finished")
	if _is_active:
		exit(ExitCodes.ACTION_COMPLETED)
