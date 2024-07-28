extends Area2D
class_name ImpactDamage

@export_flags_2d_physics var damage_matching = 6
@export var active: bool = true
@export var source: Node = null

signal damaged(body: Node, source: Node)

func _on_body_entered(body: Node2D):
	if not active:
		return
	var correct_layer = (body as CollisionObject2D).collision_mask & damage_matching
	print("layer: ", correct_layer, " has method: ", body.has_method("get_hit"))
	if correct_layer and body.has_method("get_hit"):
		print("applying damage")
		var source_node = source if source else owner
		if body is Player:
			body.get_hit(source_node)
		else:
			body.get_hit()
		damaged.emit(body, source_node)
