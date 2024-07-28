extends Enemy

@export var walking_speed = 400
var direction = 1
@onready var ledge_detector: RayCast2D = $LedgeDetector
@onready var wall_detector: RayCast2D = $WallDetector
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health > 0:
		sprite.flip_h = velocity.x > 0
	if health == 0:
		sprite.play("Death")
	if velocity.x != 0:
		sprite.play("Walk")
	if !ledge_detector.is_colliding() or is_on_obstacle():
		ledge_detector.position.x *= -1
		wall_detector.target_position.x *= -1
		direction *= -1
	
func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = walking_speed * direction
	if health == 0:
		velocity = Vector2.ZERO
	move_and_slide()

func is_on_obstacle():
	if wall_detector.is_colliding():
		return true			
	return false
	
	
func _on_hurtbox_body_entered(body: Node2D):
	var player_layer = body.get_collision_layer_value(2)
	if player_layer:
		player_hit.emit(self)
