extends RigidBody2D
class_name PlayerProjectile

@export var time_to_despawn: float = 5

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $ParticleTrail
@onready var damager: ImpactDamage = $ImpactDamage

var in_air = false
var prev_pos: Vector2

var attached_to: Node2D
var attachment_transform: Transform2D

func _physics_process(_delta):
	if in_air:
		if prev_pos.length() > 10:
			var diff = position - prev_pos
			var diff_length = diff.length()
			rotation = diff.angle() + deg_to_rad(90)
			# smooth the position from the previous position to prevent it jittering at the end
			prev_pos = position - min(diff_length, 30) / diff_length * diff
		else:
			prev_pos = position
	else:
		prev_pos = Vector2.ZERO
	if attached_to:
		if is_instance_valid(attached_to):
			var current_transform = attached_to.global_transform * attachment_transform
			transform = current_transform.scaled(Vector2.ONE / current_transform.get_scale())
		else:
			detach()

func launch(force: float):
	freeze = false
	in_air = true
	damager.active = true
	apply_central_impulse(Vector2.UP.rotated(rotation) * force)

func attach_to(node: Node2D):
	in_air = false
	particles.emitting = false
	set_deferred("freeze", true)
	linear_velocity = Vector2.ZERO

	attached_to = node
	var diff = position - prev_pos
	rotation = diff.angle() + deg_to_rad(90)
	attachment_transform = node.global_transform.affine_inverse() * transform
	await get_tree().create_timer(0.1).timeout
	damager.active = false

func detach():
	in_air = true
	particles.emitting = true
	set_deferred("freeze", false)

	prev_pos = position - Vector2.UP.rotated(rotation) * 100
	attached_to = null
	damager.active = true

func _on_body_entered(body: Node):
	if not in_air:
		return
	if body is Node2D:
		attach_to(body)

	await get_tree().create_timer(time_to_despawn).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "scale", Vector2.ZERO, 1)
	await get_tree().create_timer(1).timeout
	queue_free()
