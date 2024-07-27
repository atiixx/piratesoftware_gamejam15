extends ModeState

var projectile = preload("res://scenes/player/projectile.tscn")
var prepare_attack_projectile: PlayerProjectile

@export var cooldown = 0.5
@onready var cooldown_timer: Timer = $Cooldown

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("Attack") and prepare_attack_projectile:
		prepare_attack_projectile.launch(60)
		prepare_attack_projectile = null
		cooldown_timer.start()
	if Input.is_action_pressed("Attack") and not prepare_attack_projectile and cooldown_timer.is_stopped():
		prepare_attack_projectile = projectile.instantiate()
		prepare_attack_projectile.position = player.global_position
		owner.owner.add_child(prepare_attack_projectile)

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	if prepare_attack_projectile:
		var rotation = get_aim_vector().angle() + deg_to_rad(90)
		prepare_attack_projectile.rotation = rotation
		prepare_attack_projectile.position = player.global_position + Vector2.UP.rotated(rotation) * 100
	pass

func get_aim_vector():
	var controller_aim = Input.get_vector("Controller Aim Left", "Controller Aim Right", "Controller Aim Up", "Controller Aim Down")
	if controller_aim.length() > 0.1:
		return controller_aim
	else:
		var relative_mouse_pos = get_viewport().get_mouse_position() - player.get_global_transform_with_canvas().origin
		return relative_mouse_pos


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
