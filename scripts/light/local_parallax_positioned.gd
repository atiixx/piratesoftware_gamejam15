@tool extends Node2D

@export var motion_factor: Vector2 = Vector2(1, 1)
@export var base_position: Vector2

func _process(_delta):
	if Engine.is_editor_hint():
		base_position = Vector2(position)
	elif base_position is Vector2:
		var center_offset = get_global_transform_with_canvas().origin + (base_position - position) - get_viewport_rect().size * 0.5
		var new_offset = center_offset * (motion_factor - Vector2.ONE)
		position = base_position + new_offset
