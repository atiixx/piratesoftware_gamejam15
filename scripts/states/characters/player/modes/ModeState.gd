# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name ModeState
extends StateBase

enum WALL_DIRECTION {
	NONE,
	LEFT,
	RIGHT
}
# Typed reference to the player node.
var player: Player

# The state machine subscribes to node callbacks and delegates them to the state objects.
func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Switch Mode") and PlayerUnlocks.unlocked_shooting:
		var current_index = state_machine.all_states.find(state_machine.state.name)
		if current_index >= 0:
			state_machine.transition_to(state_machine.all_states[(current_index + 1) % state_machine.all_states.size()])
	
func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	player = owner as Player
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)
