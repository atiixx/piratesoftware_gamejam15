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
	#Slide up on Wall
	if player.velocity.y < 0:
		player.velocity.y += 20
	
	#slower slide down wall	
	player.gravity = player.base_gravity * 0.2
	player.move_and_slide()
	check_for_transition()
	handle_slope_rotation()


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	print(name)
	player.can_attack = false
	#Check where the wall is
	match get_wall_press_state():
		Enums.WALL_DIRECTION.LEFT:
			player.r_wall_collision_shape.disabled = true
			player.l_wall_collision_shape.disabled = false
			player.sprite.flip_h = false
			player.attack_sprite.flip_v = false
			player.attack_sprite.flip_h = false
			player.down_attack_sprite.flip_v = false
			player.down_attack_sprite.flip_h = false
			player.attack_sprite.position.x = player.attack_sprite_pos.x
			player.attack_collision_shape.position.x = player.attack_collision_shape_pos.x
		Enums.WALL_DIRECTION.RIGHT:
			player.l_wall_collision_shape.disabled = true
			player.r_wall_collision_shape.disabled = false
			player.sprite.flip_h = true
			player.attack_sprite.flip_v = false
			player.attack_sprite.flip_h = true
			player.down_attack_sprite.flip_v = false
			player.down_attack_sprite.flip_h = true
			player.attack_sprite.position.x = player.attack_sprite_pos.x * -1
			player.attack_collision_shape.position.x = player.attack_collision_shape_pos.x * -1
	player.collision_shape.disabled = true


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	player.can_attack = true
	player.gravity = player.base_gravity
	player.collision_shape.disabled = false
	player.l_wall_collision_shape.disabled = true
	player.r_wall_collision_shape.disabled = true

func check_for_transition():
	if(Input.is_action_just_pressed("jump")):
		var direction = 1
		match get_wall_press_state():
			Enums.WALL_DIRECTION.RIGHT:
				direction = -1
		player.can_wallslide = false
		player.wallslide_cd_timer.start()
		player.velocity = Vector2(1000 * direction, player.jump_speed)
		state_machine.transition_to("Jump")
		player.anim_tree_playback.travel("Jump")
	if(get_wall_press_state() == Enums.WALL_DIRECTION.NONE):
		if(!player.is_on_floor() and player.velocity.y > 0):
			state_machine.transition_to("Fall")
			player.anim_tree_playback.travel("Fall")
		if(player.is_on_floor() and player.velocity.x == 0):
			state_machine.transition_to("Idle")
			player.anim_tree_playback.travel("Idle")
		if(player.is_on_floor()):
			state_machine.transition_to("Walking")
			player.anim_tree_playback.travel("Walk")
