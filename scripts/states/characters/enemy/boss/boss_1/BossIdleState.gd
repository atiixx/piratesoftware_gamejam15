extends BossState

var rng = RandomNumberGenerator.new()
# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	boss.audio_streamer.get_node("IdleSound").play()
	if boss.fight_started:
		boss.state_change_timer.start()


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	boss.audio_streamer.get_node("IdleSound").stop()

func change_state():
	var random_number = rng.randi_range(0, 1)
	match random_number:
		0:
			state_machine.transition_to("Shoot")
		1:
			state_machine.transition_to("Jump")

