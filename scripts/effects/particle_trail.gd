@tool extends GPUParticles2D

@export var color: Color = Color.BLACK:
	set(new):
		color = new
		update_shader_params()
@export var fall_off: float = 2:
	set(new):
		fall_off = new
		update_shader_params()
@export var particle_size: float = 5:
	set(new):
		particle_size = new
		update_shader_params()

func _ready():
	material = material.duplicate()
	process_material = process_material.duplicate()
	update_shader_params()

func update_shader_params():
	var shader_mat = material as ShaderMaterial
	if shader_mat:
		shader_mat.set_shader_parameter("color", color)
		shader_mat.set_shader_parameter("fall_off", fall_off)
	var process_mat = process_material as ParticleProcessMaterial
	if process_mat:
		process_mat.scale_min = particle_size * 0.8
		process_mat.scale_max = particle_size * 1.3
