extends CharacterBody2D
class_name Player

@export var speed = 400.0
@export var jump_speed = -700.0
@onready var anim_tree_playback:AnimationNodeStateMachinePlayback = $Animations/AnimationTree["parameters/playback"]
@onready var anim_player: AnimationPlayer = $Animations/AnimationPlayer
@onready var state_label = $StateLabel
#Sprites
@onready var sprite := $Sprite2D
@onready var attack_sprite := $Sprite2D/AttackSprite2D
@onready var attack_sprite_pos = attack_sprite.position
@onready var down_attack_sprite := $Sprite2D/DownAttackSprite2D

@onready var attack_cd_timer := $AttackCooldown
@onready var wallslide_cd_timer := $WallSlideCooldown
@onready var character_state_machine = $CharacterStateMachine
#Raycasts
@onready var floor_raycast: RayCast2D = $Raycasts/FloorDetection
@onready var floor_raycast2: RayCast2D = $Raycasts/FloorDetection2
@onready var l_up_wall_raycast: RayCast2D = $Raycasts/LUpWallDetection
@onready var r_up_wall_raycast: RayCast2D = $Raycasts/RUpWallDetection
@onready var l_down_wall_raycast: RayCast2D = $Raycasts/LDownWallDetection
@onready var r_down_wall_raycast: RayCast2D = $Raycasts/RDownWallDetection

#Collision Shapes
@onready var collision_shape = $CollisionShape2D
@onready var l_wall_collision_shape = $WallCollisionShape2DLeft
@onready var r_wall_collision_shape = $WallCollisionShape2DRight
@onready var slide_collision_shape = $SlideCollisionShape2D
@onready var attack_collision_shape = $Hitboxes/AttackCollisionShape2D
@onready var attack_collision_shape_pos = attack_collision_shape.position
var is_attacking := false
var can_attack := true
var acc := 200
var can_wallslide := true
var health = 3
# Get the gravity from the project settings so you can sync with rigid body nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var gravity = base_gravity

signal enemy_hit(body)

func _ready():
	pass
	
func _process(delta):
	state_label.text = character_state_machine.state.name
	if can_attack:
		if(Input.is_action_pressed("Attack") and Input.is_action_pressed("down") and !is_on_floor()):
			can_attack = false
			anim_tree_playback.travel("DownAttack")
		elif (Input.is_action_pressed("Attack") and Input.is_action_pressed("up")):
			can_attack = false
			anim_tree_playback.travel("UpAttack")
		elif(Input.is_action_just_pressed("Attack")):
			can_attack = false
			anim_tree_playback.travel("Attack")
	if velocity.x != 0 and character_state_machine.state.name != "Wall":
		sprite.flip_v = false
		sprite.flip_h = velocity.x < 0
		attack_sprite.flip_v = false
		attack_sprite.flip_h = velocity.x < 0
		down_attack_sprite.flip_v = false
		down_attack_sprite.flip_h = velocity.x < 0
		if(attack_sprite.flip_h):
			attack_sprite.position.x = attack_sprite_pos.x * -1
			attack_collision_shape.position.x = attack_collision_shape_pos.x *-1
		else:
			attack_sprite.position.x = attack_sprite_pos.x
			attack_collision_shape.position.x = attack_collision_shape_pos.x

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	
func set_attacking(value):
	is_attacking = value
	if !value:
		attack_cd_timer.start()
		

func _on_cd_timer_timeout():
	if character_state_machine.state.name != "Wall":
		can_attack = true
		
func _on_wallslide_cd_timer_timeout():
	can_wallslide = true


func _on_attack_hit(body: Node2D):
	var enemy_layer = body.get_collision_layer_value(3)
	if enemy_layer:
		enemy_hit.emit(body)

func get_hit():
	$Animations/DamageAnimationPlayer.play("get_hit")
	var healthbar = $IngameUi.find_child("HealthBar")	
	var health_outline_path = 	"res://art/UI/health_outline.png"
	health -= 1
	for i in range(healthbar.get_child_count()):
		if i > health -1:
			healthbar.get_child(i).texture = load(health_outline_path)
			
	if health <= 0:
		die()
		
func die():
	print("you died")
	health = 3
	
