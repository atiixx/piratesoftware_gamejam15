# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name ModeStateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state = NodePath()

@export var all_states: Array[NodePath] = []

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: StateBase = get_node(initial_state)
var previousState: StateBase


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()
	print(state)


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Switch Mode"):
		var current_index = all_states.find(get_path_to(state))
		# print(current_index, state, all_states, get_path_to(state))
		if current_index >= 0:
			transition_to(all_states[(current_index + 1) % all_states.size()])
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not has_node(target_state_name):
		return
	state.exit()
	previousState = state
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
