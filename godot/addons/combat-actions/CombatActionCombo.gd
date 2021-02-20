extends CombatAction
class_name CombatActionCombo


func _ready() -> void:
	_is_active = true


func setup(anim_player : AnimationPlayer) -> void:
	self.animation_player = anim_player
