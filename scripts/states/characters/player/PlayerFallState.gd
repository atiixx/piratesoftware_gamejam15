extends PlayerState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:			
	handle_basic_movement(_delta)
	player.move_and_slide()
	check_for_transition()
	
# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.gravity *= 2
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.gravity = player.base_gravity

func check_for_transition():
	if(player.is_on_floor() and player.velocity.x == 0):
		state_machine.transition_to("Idle")
		player.anim_tree_playback.travel("Idle")
	if(player.is_on_floor()):
		state_machine.transition_to("Walking")
		player.anim_tree_playback.travel("Walk")
	if(player.is_on_wall_only() and get_wall_press_state() != WALL_DIRECTION.NONE):
		state_machine.transition_to("Wall")
		player.anim_tree_playback.travel("Wall")

