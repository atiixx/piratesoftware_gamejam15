extends RigidBody2D
class_name PlayerProjectile

@export var time_to_despawn: float = 5

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var damager: ImpactDamage = $ImpactDamage

var in_air = false
var update_after_landing = true
var prev_pos: Vector2

var attached_to: Node2D
var attachment_offset: Vector2
var attachment_prev_relative_pos: Vector2



func _physics_process(_delta):
	if in_air or not update_after_landing:
		update_after_landing = true
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
	if attached_to:
		if is_instance_valid(attached_to):
			position = attached_to.global_position + attachment_offset
		else:
			detach()

func launch(force: float):
	freeze = false
	in_air = true
	apply_central_impulse(Vector2.UP.rotated(rotation) * force)

func attach_to(node: Node2D):
	var position_offset = global_position - node.global_position
	attached_to = node
	attachment_offset = position_offset
	attachment_prev_relative_pos = prev_pos - global_position
	await get_tree().create_timer(0.1).timeout
	damager.active = false

func detach():
	attached_to = null
	in_air = true
	set_deferred("freeze", false)
	prev_pos = global_position + attachment_prev_relative_pos
	damager.active = true

func _on_body_entered(body: Node):
	in_air = false
	update_after_landing = false
	particles.emitting = false
	set_deferred("freeze", true)
	linear_velocity = Vector2.ZERO

	if body is Node2D:
		attach_to(body)

	await get_tree().create_timer(time_to_despawn).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($Line2D, "scale", Vector2.ZERO, 1)
	await get_tree().create_timer(1).timeout
	queue_free()
