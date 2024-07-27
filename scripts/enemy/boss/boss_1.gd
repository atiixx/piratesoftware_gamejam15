extends Boss

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite := $Sprite2D
@onready var state_label: Label = $StateLabel
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var state_change_timer: Timer = $PhaseChangeTimer
@onready var shoot_delay_timer: Timer = $ShootDelayTimer
@onready var projectile_spawns = $ProjectileSpawns
@onready var markers = owner.find_child("Markers")
@onready var camera: Camera2D = owner.get_node("CharacterParent").find_child("Camera2D")
var start_camera_pathing = false

var player_is_left = true
var fight_started = false
const JUMP_ATTACK_VECTOR: Vector2 = Vector2(600, -600)

signal finished_phase()
signal player_hit(from)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_is_left = player.global_position.x < global_position.x
	state_label.text = boss_state_machine.state.name
	if player:
		sprite.flip_v = false
		sprite.flip_h = player_is_left
		

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

func shoot():
	var spawn = ""
	var player_pos = player.global_position
	var player_left_on_shoot_start = player_pos.x < global_position.x
	if player_left_on_shoot_start:
		spawn = "R_%s"
	else:
		spawn = "L_%s"
	var projectile_scene = load("res://scenes/enemies/bosses/boss_projectile.tscn")
	var bullet = projectile_scene.instantiate()
	owner.add_child(bullet)
	bullet.position = projectile_spawns.find_child(spawn % "DOWN").global_position
	bullet.set_target(player_pos)
	if player_left_on_shoot_start:
		anim_player.play("shoot_left")
	else:
		anim_player.play("shoot_right")
	shoot_delay_timer.start()
	await shoot_delay_timer.timeout
	bullet = projectile_scene.instantiate()
	owner.add_child(bullet)
	bullet.position = projectile_spawns.find_child(spawn % "MID").global_position
	bullet.set_target(player_pos)
	if player_left_on_shoot_start:
		anim_player.play("shoot_left")
	else:
		anim_player.play("shoot_right")
	shoot_delay_timer.start()
	await shoot_delay_timer.timeout
	bullet = projectile_scene.instantiate()
	owner.add_child(bullet)
	bullet.position = projectile_spawns.find_child(spawn % "DOWN").global_position
	bullet.set_target(player_pos)
	if player_left_on_shoot_start:
		anim_player.play("shoot_left")
	else:
		anim_player.play("shoot_right")
	shoot_delay_timer.start()
	await shoot_delay_timer.timeout
	finished_phase.emit()
		
func jump_attack():
	var direction
	if player_is_left:
		direction = -1
	else:
		direction = 1
	velocity = JUMP_ATTACK_VECTOR
	velocity.x = velocity.x * direction
	await on_floor_again()
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	velocity = JUMP_ATTACK_VECTOR
	velocity.x = velocity.x * direction
	await on_floor_again()
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	velocity = JUMP_ATTACK_VECTOR
	velocity.x = velocity.x * direction
	await on_floor_again()
	velocity = Vector2.ZERO
	finished_phase.emit()

func on_floor_again():
	await get_tree().create_timer(0.1).timeout
	while not is_on_floor():
		await get_tree().process_frame


func _on_hurtbox_body_entered(body):
	var player_layer = body.get_collision_layer_value(2)
	if player_layer:
		player_hit.emit(self)

func start_fight():
	fight_started = true
	camera.limit_left = markers.find_child("CamLimitLeft").position.x
	camera.limit_right = markers.find_child("CamLimitRight").position.x
	boss_state_machine.transition_to("Idle")
