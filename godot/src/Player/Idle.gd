"""
Conditions:
	No directional input
	No attacking input


Effects:
	Reduce speed to zero


Valid transitions:
	MOVE:
		On directional input
	
	ATTACK:
		On attacking input

"""

extends PlayerState

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_light"):
		state_machine.transition_to("Attack", {"attack_event" : "attack_light"})
	
	if event.is_action_pressed("attack_heavy"):
		state_machine.transition_to("Attack", {"attack_event" : "attack_heavy"})


func physics_update(_delta: float) -> void:
	player.animation_player.play("idle")
	player.attack_global_position = player.weapon.global_position
	
	var dir := player.get_input_direction()
	if not dir == Vector2.ZERO:
		state_machine.transition_to("Move")
	
	var mouse_global_position := player.get_global_mouse_position()
	player.turn_to_face_mouse_position(mouse_global_position)

func enter(_msg := {}) -> void:
	pass
