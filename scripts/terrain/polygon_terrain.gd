extends StaticBody2D

@onready
var collider_polygon: CollisionPolygon2D = $CollisionPolygon2D
@onready
var drawn_polygon: Polygon2D = $Polygon2D
@onready
var surface_line: Line2D = $Line2D

func _ready():
	var polygon = collider_polygon.polygon
	drawn_polygon.polygon = polygon
	surface_line.points = polygon

