@tool extends StaticBody2D

@export var color: Color = Color.BLACK:
	set(new_color):
		color = new_color
		update_colors()


@onready var collider_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready var drawn_polygon: Polygon2D = $Polygon2D
@onready var surface_line: Line2D = $Line2D

func update_colors():
	if self.is_node_ready():
		drawn_polygon.color = color
		var shader_material = surface_line.material as ShaderMaterial
		shader_material.set_shader_parameter("color", color)

func match_polygon():
	var polygon = collider_polygon.polygon
	drawn_polygon.polygon = polygon
	surface_line.points = polygon

func _ready():
	match_polygon()
	update_colors()

func _process(_delta):
	if Engine.is_editor_hint():
		match_polygon()

func _get_configuration_warnings():
	if collider_polygon.transform != Transform2D():
		return ["The colliders transform should be kept at the default, otherwise the visuals will not match."]
	return []
