@tool extends StaticBody2D

# color #1e1a16

@export var color: Color = Color.BLACK:
	set(new_color):
		color = new_color
		update_color()
@export var highlight_color: Color = Color.BLACK:
	set(new_color):
		highlight_color = new_color
		update_color()
@export var flip_polygon = false:
	set(new_state):
		flip_polygon = new_state
		flip_collider_polygon()

@onready var collider_polygon: CollisionPolygon2D
@onready var drawn_polygon: Polygon2D = $Polygon2D
@onready var surface_line: Line2D = $Line2D
@onready var detail_container: Node2D = $DetailContainer

var old_polygon: PackedVector2Array
var time_to_update_polygon: float = 0

var grass = preload("res://scenes/terrain/surface_grass.tscn")

func _ready():
	collider_polygon = get_node_or_null("CollisionPolygon2D")
	surface_line.material = surface_line.material.duplicate()
	drawn_polygon.material = drawn_polygon.material.duplicate()
	update_polygon()
	update_color()

func _process(delta):
	if Engine.is_editor_hint():
		time_to_update_polygon -= delta
		if time_to_update_polygon < 0:
			update_polygon()
			time_to_update_polygon = 0.1

func flip_collider_polygon():
	if not collider_polygon:
		return
	var polygon = collider_polygon.polygon
	polygon.reverse()
	collider_polygon.polygon = polygon

func update_color():
	if self.is_node_ready():
		drawn_polygon.color = color
		var shader_material = surface_line.material as ShaderMaterial
		shader_material.set_shader_parameter("color", color)
		shader_material.set_shader_parameter("highlight_color", highlight_color)
		var polygon_material = drawn_polygon.material as ShaderMaterial
		polygon_material.set_shader_parameter("color", color)
		polygon_material.set_shader_parameter("highlight_color", highlight_color)

func update_polygon():
	if not collider_polygon:
		return
	if old_polygon and old_polygon == collider_polygon.polygon:
		return
	var polygon = collider_polygon.polygon
	old_polygon = PackedVector2Array(polygon)
	drawn_polygon.polygon = polygon
	surface_line.points = polygon
	update_details()

	# write normals to vertex colors
	var vertex_colors = PackedColorArray()
	for i in range(polygon.size()):
		var previous = polygon[i - 1]
		var current = polygon[i]
		var next = polygon[(i + 1) % polygon.size()]
		var direction = ((next - current).normalized() + (current - previous).normalized()).normalized()
		var normal = direction.rotated(deg_to_rad(-90)) * 0.5 + Vector2(0.5, 0.5)
		vertex_colors.push_back(Color(normal.x, normal.y, 0.0))
	drawn_polygon.vertex_colors = vertex_colors

func update_details():
	var polygon = collider_polygon.polygon
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
		if normal.dot(Vector2.UP) > 0.8:
			surface_lines.push_back(current)
			surface_lines.push_back(next)
			var g = grass.instantiate() as SurfaceGrass
			g.position = current
			g.end = next - current
			detail_container.add_child(g)

func _get_configuration_warnings():
	collider_polygon = get_node_or_null("CollisionPolygon2D")
	if not collider_polygon:
		return ["This node requires a CollisionPolygon2D as child node."]
	if collider_polygon.transform != Transform2D():
		return ["The colliders transform should be kept at the default, otherwise the visuals will not match."]
	return []
