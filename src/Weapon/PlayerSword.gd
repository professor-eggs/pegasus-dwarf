extends Weapon


func _ready() -> void:
	_attack_data = {
		"light_attacks" : AttackArray.new(
			[
				Attack.new("slash_lr_01", 0.8, 1.0),
				Attack.new("slash_lr_02", 0.5, 1.0),
				Attack.new("slash_rl", 1.0, 1.0)
			]
		),
		"heavy_attacks" : AttackArray.new(
			[
				Attack.new("blast", 1.0, 1.0),
				Attack.new("double_stab", 1.0, 1.0),
				Attack.new("spin", 1.5, 1.0)
			]
		),
		"_chain" : {
			"light_attacks" : ["light_attacks", "heavy_attacks"]
		}
	}
	
	_input_event_to_attack_list = {
		"attack_light" : "light_attacks",
		"attack_heavy" : "heavy_attacks"
	}

func _on_DamageArea_body_entered(body: Node) -> void:
	if not body is Enemy:
		return
	
	(body as Enemy).take_damage(attack_power)
