extends Area2D

var speed = 1250

var target_dir: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_target(target_pos: Vector2):
	target_dir = (target_pos - global_position).normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += target_dir * speed * delta


func _on_projectile_body_entered(body: Node2D):
	var hit_player_layer = body.get_collision_layer_value(2)
	if hit_player_layer and body.has_method("get_hit"):
		body.get_hit(self)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
