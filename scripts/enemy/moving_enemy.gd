extends Enemy

@export var walking_speed = 15500
var direction = 1
@onready var r_ledge_detector: RayCast2D = $RLedgeDetector
@onready var l_ledge_detector: RayCast2D = $LLedgeDetector
@onready var r_wall_detector: RayCast2D = $RWallDetector
@onready var l_wall_detector: RayCast2D = $LWallDetector

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health > 0:
		sprite.flip_h = velocity.x > 0
	if health == 0:
		sprite.play("Death")
	if velocity.x != 0:
		sprite.play("Walk")
	
	
	if !r_ledge_detector.is_colliding():
		direction = -1
	elif !l_ledge_detector.is_colliding():
		direction = 1
	elif r_wall_detector.is_colliding():
		direction = -1
	elif l_wall_detector.is_colliding():
		direction = 1
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = walking_speed * direction * delta
	if health == 0:
		velocity = Vector2.ZERO
	move_and_slide()
	
	
func _on_hurtbox_body_entered(body: Node2D):
	var player_layer = body.get_collision_layer_value(2)
	if player_layer:
		player_hit.emit(self)
