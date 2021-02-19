extends KinematicBody2D

class_name Enemy

export var health : int = 4


func take_damage(attack_strength : int = 0):
	print('took %d damage' % attack_strength)
	health -= attack_strength
	
	if health <= 0:
		queue_free()
