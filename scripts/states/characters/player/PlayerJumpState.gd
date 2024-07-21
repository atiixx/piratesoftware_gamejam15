extends PlayerState

var jumped = false
var left = false
# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass
		


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if !jumped:
		jumped = true
		player.velocity.y = player.jump_speed
		if player.wall_dash:
			if left:
				player.velocity.x += 1000
			else:
				player.velocity.x -= 1000
	handle_basic_movement(_delta)
	player.move_and_slide()
	check_for_transition()
	handle_slope_rotation()

	

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	jumped = false
	print(name)
	if state_machine.previous_state.name == "Wall":
		player.wall_dash = true
		if _msg.get("from_left"):
			left = true			
		else:
			left = false
			
			

	
# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	jumped = false
	player.wall_dash = false

func check_for_transition():
	if(!player.is_on_floor() and player.velocity.y > 0 and get_wall_press_state() == Enums.WALL_DIRECTION.NONE):
		state_machine.transition_to("Fall")
		player.anim_tree_playback.travel("Fall")
	if((Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right")) and player.is_on_floor() and !player.is_on_wall()):
		state_machine.transition_to("Walking")
		player.anim_tree_playback.travel("Walk")
	if(get_wall_press_state() != Enums.WALL_DIRECTION.NONE):
		state_machine.transition_to("Wall")
		player.anim_tree_playback.travel("Wall")
