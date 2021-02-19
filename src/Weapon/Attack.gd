extends Resource
class_name Attack

var anim_name : String
var play_speed : float
var damage_factor : float

func _init(
	anim_name : String,
	play_speed : float = 1.0,
	damage_factor : float = 1.0
) -> void:
	self.anim_name = anim_name
	self.play_speed = play_speed
	self.damage_factor = damage_factor
