"""
Conditions:
	Any attacking input
	Combo attack


Effects:
	Decelerate to a stop
	Initiate the equipped weapon's attack
	Manage combos


Valid transitions:
	IDLE:
		Attack animation completed AND no attacking input

"""

extends PlayerState


func enter(_msg := {}) -> void:
	state_machine.transition_to("Idle")


func handle_input(_event: InputEvent) -> void:
	pass
