@tool extends Node2D

func _draw():
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, 5, Color.RED)
