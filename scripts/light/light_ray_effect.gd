@tool extends ReferenceRect

@export var strength: float = 0.2:
	set(new):
		strength = new
		update_shader()

@onready var rect: ColorRect = $ColorRect
@onready var node: Node2D = $Node2D

func _ready():
	rect.material = rect.material.duplicate()

func update_shader():
	var material = rect.material as ShaderMaterial
	material.set_shader_parameter("strength", strength)

func _process(_delta):
	node.position = size / 2

	var position_on_canvas = (get_global_transform_with_canvas().origin + size * 0.5) / get_viewport_rect().size
	var shader_material = rect.material as ShaderMaterial
	shader_material.set_shader_parameter("origin", position_on_canvas)
	# var camera = get_viewport().get_camera_2d()
	# if camera:
	# 	var relative_position = global_position + size * 0.5 - camera.get_screen_center_position()
	# 	var position_in_camera = relative_position * camera.zoom / get_viewport_rect().size
	# 	var shader_material = rect.material as ShaderMaterial
	# 	shader_material.set_shader_parameter("origin", position_in_camera + Vector2(0.5, 0.5))

