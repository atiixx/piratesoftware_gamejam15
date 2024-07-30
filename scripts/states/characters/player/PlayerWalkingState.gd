extends PlayerState

#sliding not used currently
var sliding = false

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	#unused slide
	#if(Input.is_action_just_pressed("down")):
		#sliding = true
		#start_slide()
		pass
		
		
	


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	handle_basic_movement(_delta)
	player.move_and_slide()
	handle_slope_rotation()
	check_for_transition()	
	


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	print(name)


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
	#for unused sliding
	#sliding = false
	#player.collision_shape.disabled= false
	#player.slide_collision_shape.disabled = true

func check_for_transition():
	if(Input.is_action_just_pressed("jump")):
		state_machine.transition_to("Jump")
		player.anim_tree_playback.travel("Jump")
	if(!player.is_on_floor() and player.velocity.y > 0 and !player.is_on_wall()):
		state_machine.transition_to("Fall")
		player.anim_tree_playback.travel("Fall")
	if(player.is_on_wall_only() and get_wall_press_state() != Enums.WALL_DIRECTION.NONE):
		state_machine.transition_to("Wall")
		player.anim_tree_playback.travel("Wall")
	if(!(Input.is_action_pressed("left") or Input.is_action_pressed("right")) and player.velocity.x == 0):
		state_machine.transition_to("Idle")
		player.anim_tree_playback.travel("Idle")

#Sliding not implemented yet
func start_slide():
	player.anim_tree_playback.travel("Slide")
	player.collision_shape.disabled= true
	player.slide_collision_shape.disabled = false
	var vel_pre_slide = player.velocity.x
	var direction = Input.get_axis("left", "right")
	player.velocity.x += 500 * direction
	await get_tree().create_timer(0.5).timeout
	sliding = false
	player.velocity.x = vel_pre_slide
	player.anim_tree_playback.travel("Walk")
	player.collision_shape.disabled= false
	player.slide_collision_shape.disabled = true
