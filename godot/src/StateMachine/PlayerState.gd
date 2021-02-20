# Virtual base class for all states.
class_name PlayerState
extends State

# We store a reference to the state machine to call its `transition_to()` method directly.
var player : Player = null

func _ready() -> void:
	yield(owner, "ready")
	player = owner as Player
	assert(player != null)
