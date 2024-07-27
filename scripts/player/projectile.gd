extends RigidBody2D
class_name PlayerProjectile

var in_air = false
var update_after_landing = true
var prev_pos: Vector2

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var despawn_timer: Timer = $DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if in_air or not update_after_landing:
		update_after_landing = true
		# rotation = linear_velocity.angle() + deg_to_rad(90)
		if prev_pos.length() > 10:
			var diff = position - prev_pos
			var diff_length = diff.length()
			rotation = diff.angle() + deg_to_rad(90)
			# smooth the position from the previous position to prevent it jittering at the end
			prev_pos = position - min(diff_length, 40) / diff_length * diff
		else:
			prev_pos = position
	else:
		prev_pos = Vector2.ZERO

func launch(force: float):
	freeze = false
	in_air = true
	apply_central_impulse(Vector2.UP.rotated(rotation) * force)


func _on_body_entered(body:Node):
	in_air = false
	update_after_landing = false
	particles.emitting = false
	set_deferred("freeze", true)
	linear_velocity = Vector2.ZERO

	despawn_timer.start()
	var tween = get_tree().create_tween()
	# tween.tween_property($Line2D, "width", 0, 1)
	tween.tween_property($Line2D, "default_color", Color(0, 0, 0, 0), 1)


func _on_despawn_timer_timeout():
	queue_free()
