extends CharacterBody2D
class_name Player

@export var speed = 400.0
@export var jump_speed = -700.0
@onready var anim_tree_playback:AnimationNodeStateMachinePlayback = $Animations/AnimationTree["parameters/playback"]
@onready var sprite := $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var l_wall_collision_shape = $WallCollisionShape2DLeft
@onready var r_wall_collision_shape = $WallCollisionShape2DRight
var acc := 200

# Get the gravity from the project settings so you can sync with rigid body nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var gravity = base_gravity

func _ready():
	pass
	
func _process(delta):
	if velocity.x != 0 and !is_on_wall():
		sprite.flip_v = false
		sprite.flip_h = velocity.x < 0


func _physics_process(delta):
	pass
	
