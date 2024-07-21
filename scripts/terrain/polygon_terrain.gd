@tool extends Polygon2D

@export var base_color: Color = Color.BLACK:
	set(new_color):
		base_color = new_color
		update_color()
@export var highlight_color: Color = Color.BLACK:
	set(new_color):
		highlight_color = new_color
		update_color()
@export var flip_polygon = false:
	set(new_state):
		flip_polygon = new_state
		flip_collider_polygon()

@onready var collider_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var surface_line: Line2D = $Line2D
@onready var detail_container: Node2D = $DetailContainer

var old_polygon: PackedVector2Array
var time_to_update_polygon: float = 0

var grass = preload("res://scenes/terrain/surface_grass.tscn")

func _ready():
	surface_line.material = surface_line.material.duplicate()
	self.material = self.material.duplicate()
	update_polygon()
	update_color()

func _process(delta):
	if Engine.is_editor_hint():
		time_to_update_polygon -= delta
		if time_to_update_polygon < 0:
			update_polygon()
			time_to_update_polygon = 0.1

func flip_collider_polygon():
	if Engine.is_editor_hint():
		var pol = polygon
		pol.reverse()
		polygon = pol

func update_color():
	if self.is_node_ready():
		var shader_material = surface_line.material as ShaderMaterial
		shader_material.set_shader_parameter("color", base_color)
		shader_material.set_shader_parameter("highlight_color", highlight_color)
		var polygon_material = self.material as ShaderMaterial
		polygon_material.set_shader_parameter("color", base_color)
		polygon_material.set_shader_parameter("highlight_color", highlight_color)

func update_polygon():
	if old_polygon and old_polygon == self.polygon:
		return
	old_polygon = PackedVector2Array(polygon)
	collider_polygon.polygon = polygon
	surface_line.points = polygon
	update_details()

	# write normals to vertex colors
	var new_vertex_colors = PackedColorArray()
	for i in range(polygon.size()):
		var previous = polygon[i - 1]
		var current = polygon[i]
		var next = polygon[(i + 1) % polygon.size()]
		var direction = ((next - current).normalized() + (current - previous).normalized()).normalized()
		var normal = direction.rotated(deg_to_rad(-90)) * 0.5 + Vector2(0.5, 0.5)
		new_vertex_colors.push_back(Color(normal.x, normal.y, 0.0))
	self.vertex_colors = new_vertex_colors

func update_details():
	for child in detail_container.get_children():
		child.queue_free()

	for i in range(polygon.size()):
		var current = polygon[i]
		var next = polygon[(i + 1) % polygon.size()]
		var along = next - current
		var normal = along.rotated(deg_to_rad(-90)).normalized()
		if normal.dot(Vector2.UP) > 0.8:
			var g = grass.instantiate() as SurfaceGrass
			g.position = current
			g.end = next - current
			detail_container.add_child(g)

