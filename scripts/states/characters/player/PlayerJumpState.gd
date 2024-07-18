extends PlayerState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if(!player.is_on_floor() and player.velocity.y > 0 and !player.is_on_wall()):
		state_machine.transition_to("Fall")
		player.anim_tree_playback.travel("Fall")
	if(player.velocity.x != 0 and !player.is_on_wall()):
		state_machine.transition_to("Walking")
		player.anim_tree_playback.travel("Walk")
	if(player.is_on_floor() and player.velocity.x == 0 and !player.is_on_wall()):
		state_machine.transition_to("Idle")
		player.anim_tree_playback.travel("Idle")
	if(player.is_on_wall()):
		state_machine.transition_to("Wall")
		player.anim_tree_playback.travel("Wall")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
