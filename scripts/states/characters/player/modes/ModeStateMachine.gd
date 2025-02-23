# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name ModeStateMachine
extends Node

# Emitted when transitioning to a new state.
signal transitioned(state_name)

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state = NodePath()

@export var all_states: Array[String] = []

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: ModeState = null
var previousState: ModeState


func _ready() -> void:
	await owner.ready
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	setup_state(initial_state)


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func setup_state(target_state_name: String, msg: Dictionary = {}):
	state = get_node(target_state_name)
	state.enter(msg)
	var mode_label = state.player.get_node("IngameUi").find_child("ModeLabel") as Label
	mode_label.text = "👊" if state.name == "Basic" else "🏹" if state.name == "Shooting" else String(state.name)

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
	setup_state(target_state_name, msg)
	emit_signal("transitioned", state.name)
