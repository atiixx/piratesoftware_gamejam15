extends CharacterBody2D
class_name Player

@export var speed = 400.0
@export var jump_speed = -700.0
@onready var anim_tree_playback:AnimationNodeStateMachinePlayback = $Animations/AnimationTree["parameters/playback"]
@onready var sprite := $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var l_wall_collision_shape = $WallCollisionShape2DLeft
@onready var r_wall_collision_shape = $WallCollisionShape2DRight
@onready var ray_left: RayCast2D = $WalldetectorLeft
@onready var ray_right: RayCast2D = $WalldetectorRight

# Get the gravity from the project settings so you can sync with rigid body nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var gravity = base_gravity

func _ready():
	pass
	
func _process(delta):
	ray_left.target_position.y = collision_shape.shape.size.x / 3
	ray_right.target_position.y = collision_shape.shape.size.x / 3
	if velocity.x != 0 and !on_wall():
		sprite.flip_v = false
		sprite.flip_h = velocity.x < 0
	if ray_right.is_colliding():
		sprite.flip_v = false
		sprite.flip_h = true
	elif ray_left.is_colliding():
		sprite.flip_v = false
		sprite.flip_h = false

func _physics_process(delta):
	handle_basic_movement(delta)

	#fast fall
	if Input.is_action_just_pressed("down"):
		gravity = base_gravity * 2
	elif Input.is_action_just_released("down"):
		gravity = base_gravity
	
	#long and short jump
	if Input.is_action_just_pressed("jump"):
		gravity = base_gravity * 0.4
	elif Input.is_action_just_released("jump"):
		gravity = base_gravity

	move_and_slide()
	
func handle_basic_movement(delta):	
	# Add the gravity.
	velocity.y += gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	if Input.is_action_just_pressed("jump") and on_wall():
		velocity.y = jump_speed / 2
		velocity.x = -jump_speed / 2
		
	# Get the input direction.
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed

		
func on_wall():
	return ray_left.is_colliding() or ray_right.is_colliding()
