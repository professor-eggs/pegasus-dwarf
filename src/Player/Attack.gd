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

var _current_attack_index : int = 0


func enter(msg := {}) -> void:
	_current_attack_index = 0
	
	if "attack_event" in msg:
		if msg.attack_event in ["attack_light", "attack_heavy"]:
			player.weapon.attack(_current_attack_index, msg.attack_event)
			return
	
	player.weapon.attack(_current_attack_index, msg.attack_event)


func handle_input(event: InputEvent) -> void:
	# If attack is called while still in attack state then this is a combo
	if event.is_action_pressed("attack_light"):
		_current_attack_index += 1
		player.weapon.attack(_current_attack_index, "attack_light")
	
	if event.is_action_pressed("attack_heavy"):
		_current_attack_index += 1
		player.weapon.attack(_current_attack_index, "attack_heavy")


func on_Player_attack_completed() -> void:
	state_machine.transition_to("Idle")
