@tool extends Line2D
class_name Grass

@export var surface_normal: Vector2
@export var length: float = 10:
	set(new_length):
		length = new_length
		update_points()

func _ready():
	update_points()

func update_points():
	var p = PackedVector2Array()
	p.push_back(Vector2.ZERO)
	var point_count = 4
	for i in range(point_count):
		var factor = (i + 1.0) / point_count
		var normal_factor = 1 - pow(1 - factor, 2)
		p.push_back(Vector2.UP * length * factor * 0.6 + surface_normal * length * normal_factor * 0.4)
	points = p
