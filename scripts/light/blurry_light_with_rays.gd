@tool extends ReferenceRect

@export var light_intensity := 1.0:
	set(new):
		light_intensity = new
		update_shader_params()
@export var color := Color.WHITE:
	set(new):
		color = new
		update_shader_params()
@onready var light_glow := $LightGlow as ColorRect
@onready var light_rays := $LightRays as ColorRect

func _ready():
	light_glow.material = light_glow.material.duplicate()
	light_rays.material = light_rays.material.duplicate()
	update_shader_params()

func update_shader_params():
	if not light_glow or not light_rays:
		return
	var glow_material = light_glow.material as ShaderMaterial
	var rays_material = light_rays.material as ShaderMaterial
	glow_material.set_shader_parameter("color", color)
	glow_material.set_shader_parameter("strength", light_intensity)
	rays_material.set_shader_parameter("color", color)
	rays_material.set_shader_parameter("glow_strength", light_intensity)

func _process(_delta):
	var camera = get_viewport().get_camera_2d()
	if light_rays:
		var position_on_canvas = get_global_transform_with_canvas().origin + size * 0.5
		if camera:
			# no clue why this workds (necessary when camera position smoothing is enabled)
			position_on_canvas += (camera.get_screen_center_position() - camera.get_target_position()) * 0.25
		var shader_material = light_rays.material as ShaderMaterial
		shader_material.set_shader_parameter("origin", position_on_canvas / get_viewport_rect().size)
