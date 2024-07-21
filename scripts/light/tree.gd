@tool extends Node2D

@export var color: Color = Color.BLACK:
	set(new):
		color = new
		generate()
@export var trunk_height: float = 500:
	set(new):
		trunk_height = new
		generate()


func _ready():
	generate()

func generate():
	if not is_node_ready():
		return
	for child in get_children():
		child.queue_free()
	var rng = RandomNumberGenerator.new()
	rng.seed = hash("tree")
	var trunk := Line2D.new()

	var trunk_curve := Curve.new()
	trunk.width = trunk_height * 0.2
	trunk.default_color = color

	trunk_curve.add_point(Vector2(0, 1), 0.0, -2, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	trunk_curve.add_point(Vector2(1, 0.5), -0.5, 0, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	trunk.width_curve = trunk_curve
	
	var points = PackedVector2Array()
	var count := 10
	for i in range(count):
		points.push_back(Vector2.UP * (float(i) / (count - 1)) * trunk_height)
	trunk.points = points

	add_child(trunk)

	for i in range(8):
		var dir = rng.randf_range(-1, 1)
		var branch_width = trunk_height * 0.03
		var pos = Vector2.RIGHT * dir * branch_width + Vector2.UP * (trunk_height - branch_width * 0.5)
		var angle = dir * PI * 0.4
		generate_branch(rng, trunk, pos, angle, trunk_height * 0.8, branch_width, 3)

func generate_branch(rng: RandomNumberGenerator, parent: Node2D, position: Vector2, start_angle: float, length: float, thickness: float, depth: int):
	var dir_vector = Vector2.UP.rotated(start_angle)

	var branch = Line2D.new()
	branch.width = thickness
	branch.default_color = color
	branch.position = position

	var branch_curve := Curve.new()
	branch_curve.add_point(Vector2(0, 1), 0.0, -0.3, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	branch_curve.add_point(Vector2(0.5, 0.4), -0.3, 0, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	branch_curve.add_point(Vector2(1, 0.1), -0.1, 0, Curve.TANGENT_FREE, Curve.TANGENT_FREE)
	branch.width_curve = branch_curve

	var branch_points = PackedVector2Array()
	var branch_point_count := 10
	for i in range(branch_point_count):
		# branch_points.push_back(dir_vector * (float(i) / (branch_point_count - 1)) * length)
		branch_points.push_back(position_on_branch(start_angle, length, float(i) / (branch_point_count - 1)))
	branch.points = branch_points
	parent.add_child(branch)

	if depth > 1:
		var sub_branch_count = int(length / thickness * 0.3)
		for i in range(sub_branch_count):
			var dist_factor = (rng.randf() + pow(rng.randf(), 1.5)) * 0.5
			var pos = position_on_branch(start_angle, length, dist_factor)
			var dir = sign(rng.randf() - 0.5)
			var angle = (rng.randf_range(0.2, 0.4) + rng.randf_range(0.1, 1.0)) * 0.5 * PI * 0.5 * dir
			var size_factor = pow(1 - dist_factor, 0.5) * 0.5
			generate_branch(rng, branch, pos, start_angle + angle, length * size_factor, thickness * size_factor * 1.5, depth - 1)


func position_on_branch(start_angle: float, length: float, percentage: float):
	var dir = Vector2.UP.rotated(start_angle)
	var initial_percent = 1 - (percentage * 0.3)
	return (dir * initial_percent + Vector2.UP * (1 - initial_percent)) * length * percentage
