extends CharacterBody2D
class_name Player

@export var speed = 400.0
@export var jump_speed = -700.0
@onready var anim_tree_playback:AnimationNodeStateMachinePlayback = $Animations/AnimationTree["parameters/playback"]
@onready var anim_player: AnimationPlayer = $Animations/AnimationPlayer

#Sprites
@onready var sprite := $Sprite2D
@onready var attack_sprite := $Sprite2D/AttackSprite2D
@onready var attack_sprite_pos = attack_sprite.position
@onready var down_attack_sprite := $Sprite2D/DownAttackSprite2D

@onready var attack_cd_timer := $AttackCooldown

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

# Get the gravity from the project settings so you can sync with rigid body nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var gravity = base_gravity

func _ready():
	pass
	
func _process(delta):
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
	if velocity.x != 0 and !is_on_wall():
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
	can_attack = true
