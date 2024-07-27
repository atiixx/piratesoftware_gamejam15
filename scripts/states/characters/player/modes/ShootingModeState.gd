extends ModeState

var projectile = preload("res://scenes/player/projectile.tscn")
var prepare_attack_projectile: PlayerProjectile

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("Attack") and prepare_attack_projectile:
		prepare_attack_projectile.launch(60)
		prepare_attack_projectile = null
	if Input.is_action_just_pressed("Attack") and not prepare_attack_projectile:
		prepare_attack_projectile = projectile.instantiate()
		prepare_attack_projectile.position = player.global_position
		owner.owner.add_child(prepare_attack_projectile)

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if prepare_attack_projectile:
		var relative_mouse_pos = get_viewport().get_mouse_position() - player.get_global_transform_with_canvas().origin
		var rotation = relative_mouse_pos.angle() + deg_to_rad(90)
		prepare_attack_projectile.rotation = rotation
		prepare_attack_projectile.position = player.global_position + Vector2.UP.rotated(rotation) * 100
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
