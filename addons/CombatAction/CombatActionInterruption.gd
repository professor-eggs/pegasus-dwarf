extends Resource
class_name CombatActionInterruption

var time

func _init() -> void:
	time = OS.get_system_time_msecs()
