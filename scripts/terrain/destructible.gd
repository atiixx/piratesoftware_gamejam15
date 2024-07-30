extends CollisionObject2D

func _on_body_entered(body: Node2D):
	if (body as CollisionObject2D).collision_layer & 8:
		queue_free()
