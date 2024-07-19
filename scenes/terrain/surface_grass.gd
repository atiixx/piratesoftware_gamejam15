@tool extends Node2D
class_name SurfaceGrass

@export var end: Vector2 = Vector2(100, 0):
	set(new_end):
		end = new_end
		setup_grass()
@export var density: float = 0.05:
	set(new_density):
		density = new_density
		setup_grass()

var grass_positions: Array[Vector2]
var grass_sizes: Array[Vector2]
var grass_angles: Array[float]
var grass_velocities: Array[float]

func _ready():
	setup_grass()

func _process(delta):
	var global_pos = global_position
	for i in range(grass_positions.size()):
		var pos = global_pos + grass_positions[i]
		var angle = grass_angles[i]
		var spring_force = -angle * 5
		var dampen_force = grass_velocities[i] * grass_velocities[i] * -sign(grass_velocities[i]) * 0.4
		var wind_strength = (noise(Vector2(pos.x * 0.001, Time.get_ticks_msec() * 0.00005)) - 0.5) * 50
		var direction = Vector2.from_angle(angle)
		var wind_force = Vector2(wind_strength, 0).dot(direction)
		var force = spring_force + wind_force + dampen_force
		grass_velocities[i] += force * delta
		grass_angles[i] += grass_velocities[i] * delta
	queue_redraw()

func setup_grass():
	grass_positions = []
	grass_angles = []
	grass_velocities = []
	var rng = RandomNumberGenerator.new()
	rng.seed = hash("grass")
	var count = int(end.length() * density)
	for i in range(count):
		var pos_percent = rng.randf()
		var pos = end * pos_percent
		grass_positions.push_back(pos)
		grass_sizes.push_back(Vector2(
			rng.randf_range(6, 12),
			rng.randf_range(30, 70)
		))
		grass_angles.push_back(0)
		grass_velocities.push_back(0)
	queue_redraw()

func _draw():
	var point_count = 5
	var normal = (end.rotated(deg_to_rad(-90)).normalized() * Vector2.DOWN).normalized()
	for i in range(grass_positions.size()):
		var pos = grass_positions[i]
		var angle = grass_angles[i]
		var size = grass_sizes[i]
		# var velocity = grass_velocities[i]
		var direction = Vector2.from_angle(angle + deg_to_rad(-90))
		var current_pos = Vector2(pos)
		var center_points = []
		for j in range(point_count):
			center_points.push_back(current_pos)
			var normal_factor = (1 - j / (point_count - 1.0))
			current_pos = current_pos + (normal * normal_factor + direction * (1 - normal_factor)) * (float(1) / (point_count - 1) * size.y)
		var polygon = []
		for j in range(point_count):
			var before = center_points[j - 1]
			var current = center_points[j]
			var next = center_points[(j + 1) % point_count]
			var dir: Vector2
			if j == 0:
				dir = (next - current).normalized()
			elif j + 1 == point_count:
				dir = (current - before).normalized()
			else:
				dir = ((next - current).normalized() + (current - before).normalized()).normalized()
			var tangent = dir.rotated(deg_to_rad(90))
			var offset = size.x * 0.5 * (1 - (j / (point_count - 1.0)))
			polygon.push_back(current + tangent * offset)
			polygon.push_front(current - tangent * offset)
		draw_colored_polygon(PackedVector2Array(polygon), Color.BLACK)

	pass






func random(uv: Vector2):
	uv = Vector2(
		uv.dot(Vector2(127.1, 311.7)),
		uv.dot(Vector2(269.5, 183.3))
	)
	return Vector2(-1.0, -1.0) + 2.0 * vec_frac(Vector2(sin(uv.x), sin(uv.y)) * 43758.5453123);

func frac(val: float):
	return val - int(val)
func vec_frac(vec: Vector2):
	return Vector2(frac(vec.x), frac(vec.y))
func mix(a: float, b: float, t: float):
	return a * (1 - t) + b * t
func vec_smoothstep(a: float, b: float, c: Vector2):
	return Vector2(smoothstep(a, b, c.x), smoothstep(a, b, c.y))

func noise(uv: Vector2):
	var uv_index = uv.floor()
	var uv_fract = vec_frac(uv)

	var blur = vec_smoothstep(0.0, 1.0, uv_fract)

	return mix(
		mix(
			random(uv_index + Vector2(0.0, 0.0)).dot(uv_fract - Vector2(0.0, 0.0)),
			random(uv_index + Vector2(1.0, 0.0)).dot(uv_fract - Vector2(1.0, 0.0)),
			blur.x
		),
		mix(
			random(uv_index + Vector2(0.0, 1.0)).dot(uv_fract - Vector2(0.0, 1.0)),
			random(uv_index + Vector2(1.0, 1.0)).dot(uv_fract - Vector2(1.0, 1.0)),
			blur.x
		),
		blur.y
	) + 0.5
