extends Enemy

@export var flying_speed = 8000
@onready var player_detector: RayCast2D = $PlayerDetector
@export var PLAYER_RAYCAST_LENGTH = 1600
@onready var state_label = $StateLabel
var target: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_label.text = enemy_state_machine.state.name
	sprite.flip_h = velocity.x < 0
	var direction_to_player = global_position.direction_to(player.global_position)
	player_detector.target_position = direction_to_player * PLAYER_RAYCAST_LENGTH
	
func _physics_process(delta):
	pass
		
			

	
func _on_hurtbox_body_entered(body: Node2D):
	var player_layer = body.get_collision_layer_value(2)
	if player_layer:
		player_hit.emit(self)
