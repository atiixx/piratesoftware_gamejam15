extends EnemyState


# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if enemy.player_detector.is_colliding():
		if enemy.player_detector.get_collider_rid() == enemy.player.get_rid():
			enemy.target = (enemy.player.global_position - enemy.global_position).normalized()
		else:
			enemy.target = Vector2.ZERO
			state_machine.transition_to("Idle")
	else:
		enemy.target = Vector2.ZERO
		state_machine.transition_to("Idle")


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	enemy.velocity = enemy.target * enemy.flying_speed * _delta
	enemy.move_and_slide()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	enemy.noticed_sound.play()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
