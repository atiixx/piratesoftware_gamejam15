@tool extends StaticBody2D

@export var color: Color = Color.BLACK:
	set(new_color):
		color = new_color
		update_color()

@onready var collider_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var drawn_polygon: Polygon2D = $Polygon2D
@onready var surface_line: Line2D = $Line2D
@onready var detail_container: Node2D = $DetailContainer

var grass = preload("res://scenes/terrain/grass.tscn")

func update_color():
	if self.is_node_ready():
		drawn_polygon.color = color
		var shader_material = surface_line.material as ShaderMaterial
		shader_material.set_shader_parameter("color", color)

func update_polygon():
	if not collider_polygon:
		return
	var polygon = collider_polygon.polygon
	drawn_polygon.polygon = polygon
	surface_line.points = polygon
	update_details()

func update_details():
	var polygon = collider_polygon.polygon
	var line_normals: Array[Vector2] = []
	var surface_lines: Array[Vector2] = []
	for child in detail_container.get_children():
		child.queue_free()

	var rng = RandomNumberGenerator.new()
	rng.seed = hash("testing")
	for i in range(polygon.size()):
		var current = polygon[i]
		var next = polygon[(i + 1) % polygon.size()]
		var along = next - current
		var normal = along.rotated(deg_to_rad(-90)).normalized()
		if normal.dot(Vector2.UP) > 0.9:
			surface_lines.push_back(current)
			surface_lines.push_back(next)
			for j in range(int(along.length() / 20.0)):
				var percent = rng.randf_range(0, 1)
				var pos = current + along * percent
				var g = grass.instantiate() as Grass
				g.surface_normal = normal
				g.position = pos
				g.default_color = color
				g.length = rng.randf_range(30, 50)
				detail_container.add_child(g)

		line_normals.push_back(normal)

func _ready():
	update_polygon()
	update_color()

func _process(_delta):
	if Engine.is_editor_hint():
		update_polygon()

func _get_configuration_warnings():
	if not collider_polygon:
		return ["This node requires a CollisionPolygon2D as child node."]
	if collider_polygon.transform != Transform2D():
		return ["The colliders transform should be kept at the default, otherwise the visuals will not match."]
	return []
