extends PlayerState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	player.gravity = player.base_gravity * 0.2
	if(Input.is_action_just_pressed("jump") and player.velocity.y < 0):
		state_machine.transition_to("Jump")
		player.anim_tree_playback.travel("Jump")
	if(!player.on_wall()):
		if(!player.is_on_floor() and player.velocity.y > 0):
			state_machine.transition_to("Fall")
			player.anim_tree_playback.travel("Fall")
		if(player.velocity.x != 0):
			state_machine.transition_to("Walking")
			player.anim_tree_playback.travel("Walk")
		if(player.is_on_floor() and player.velocity.x == 0):
			state_machine.transition_to("Idle")
			player.anim_tree_playback.travel("Idle")


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	player.velocity.y = 0
	player.collision_shape.disabled = true
	if player.ray_left.is_colliding():
		player.l_wall_collision_shape.disabled = false
	if player.ray_right.is_colliding():
		player.r_wall_collision_shape.disabled = false


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.gravity = player.base_gravity
	player.collision_shape.disabled = false
	player.l_wall_collision_shape.disabled = true
	player.r_wall_collision_shape.disabled = true

