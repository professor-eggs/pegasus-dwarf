# Virtual base class for all states.
class_name EnemyState
extends State

# We store a reference to the state machine to call its `transition_to()` method directly.
var enemy : Enemy = null

func _ready() -> void:
	yield(owner, "ready")
	enemy = owner as Enemy
	assert(enemy != null)
