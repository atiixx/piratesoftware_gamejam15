extends Boss

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var state_change_timer: Timer = $PhaseChangeTimer
@onready var shoot_delay_timer: Timer = $ShootDelayTimer
@onready var projectile_spawns = $ProjectileSpawns
@onready var markers = owner.find_child("Markers")
@onready var camera: Camera2D = owner.get_node("CharacterParent").find_child("Camera2D")
var rng = RandomNumberGenerator.new()
var start_camera_pathing = false


var player_is_left = true
var fight_started = false
const JUMP_ATTACK_VECTOR: Vector2 = Vector2(600, -600)

signal finished_phase()
signal player_hit(from)
signal change_theme()
# Called when the node enters the scene tree for the first time.
func _ready():
	health = 35

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss_state_machine.state.name == "Idle" and !getting_hit and health > 0:
		sprite.play("IDLE")
	elif boss_state_machine.state.name == "Jump" and !getting_hit and health > 0:
		sprite.play("FLYING")
		
	player_is_left = player.global_position.x < global_position.x
	if player:
		sprite.flip_v = false
		sprite.flip_h = !player_is_left
		

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

func shoot():
	var spawn = ""
	var player_pos = player.global_position
	var player_left_on_shoot_start = player_pos.x < global_position.x
	var projectile_scene = load("res://scenes/enemies/bosses/boss_projectile.tscn")
	if player_left_on_shoot_start:
		spawn = "R_%s"
	else:
		spawn = "L_%s"
	var shot_number = rng.randi_range(2, 6)
	var spawn_point_string = "DOWN"
	for i in range(shot_number):
		sprite.play("ATTACK")
		var rand_num = rng.randi_range(0, 3)
		match rand_num:
			0:
				spawn_point_string = "DOWN"
			1:
				spawn_point_string = "MID"
			2:
				spawn_point_string = "UP"
			3:
				spawn_point_string = "DOWN"
		var bullet = projectile_scene.instantiate()
		owner.add_child(bullet)
		bullet.position = projectile_spawns.find_child(spawn % spawn_point_string).global_position
		bullet.set_target(player_pos)
		audio_streamer.get_node("ShootSound").play()
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
	audio_streamer.get_node("GroundPound").play()
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	velocity = JUMP_ATTACK_VECTOR
	velocity.x = velocity.x * direction
	await on_floor_again()
	audio_streamer.get_node("GroundPound").play()
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.2).timeout
	velocity = JUMP_ATTACK_VECTOR
	velocity.x = velocity.x * direction
	await on_floor_again()
	audio_streamer.get_node("GroundPound").play()
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
	change_theme.emit()
	fight_started = true
	boss_health.set_deferred("visible", true)
	camera.limit_left = markers.find_child("CamLimitLeft").global_position.x
	camera.limit_right = markers.find_child("CamLimitRight").global_position.x
	boss_state_machine.transition_to("Idle")
