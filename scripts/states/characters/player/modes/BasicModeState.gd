extends ModeState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if player.can_attack:
		if(Input.is_action_pressed("Attack") and Input.is_action_pressed("down") and !player.is_on_floor()):
			player.can_attack = false
			player.is_attacking = true
			player.anim_tree_playback.travel("DownAttack")				
			player.attack_cd_timer.start()
		elif (Input.is_action_pressed("Attack") and Input.is_action_pressed("up")):
			player.can_attack = false
			player.is_attacking = true
			player.anim_tree_playback.travel("UpAttack")
			player.attack_cd_timer.start()
		elif(Input.is_action_just_pressed("Attack")):
			player.can_attack = false
			player.is_attacking = true
			player.anim_tree_playback.travel("Attack")
			player.attack_cd_timer.start()


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	check_for_transitions()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

func check_for_transitions():
	#How to switch between modes?
	pass
