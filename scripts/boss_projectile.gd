extends Area2D

var speed = 250

signal player_hit

var target_dir: Vector2 = Vector2.ZERO
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target(target_pos: Vector2):
	target_dir = (target_pos - global_position).normalized()
	if target_dir.x > 0:
		direction = 1
	else:
		direction = -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += direction * speed * delta


func _on_projectile_body_entered(body: Node2D):
	var hit_player_layer = body.get_collision_layer_value(2)
	if hit_player_layer:
		player_hit.emit()
		queue_free()
