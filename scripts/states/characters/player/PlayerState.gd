# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends StateBase

# Typed reference to the player node.
var player: Player

func _ready() -> void:
	# The states are children of the `Player` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	await owner.ready
	# The `as` keyword casts the `owner` variable to the `Player` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	player = owner as Player
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Player.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(player != null)

func handle_basic_movement(delta):
	#fast fall
	if Input.is_action_just_pressed("down"):
		player.gravity = player.base_gravity * 1.7
	elif Input.is_action_just_released("down"):
		player.gravity = player.base_gravity
	
	#long and short jump
	if Input.is_action_just_pressed("jump"):
		player.gravity = player.base_gravity * 0.6
	elif Input.is_action_just_released("jump"):
		player.gravity = player.base_gravity

	var direction = Input.get_axis("left", "right")
	
	
	#remove control of player shortly after walldash for smoother walldash
	if player.wall_dash and player.velocity.y < player.jump_speed / 3:
		pass
	elif player.is_attacking:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 0.1)
	else:
		#Acceleration and Deceleration
		if direction < 0:
			if player.velocity.x > -player.speed:
				player.velocity.x -= player.acc
		elif direction > 0:
			if player.velocity.x < player.speed:
				player.velocity.x += player.acc
		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, 1)


func handle_slope_rotation():
	var different_collisions = false
	if player.floor_raycast.is_colliding() and player.floor_raycast2.is_colliding():
		var floor_collision_normal1 = player.floor_raycast.get_collision_normal()
		var floor_collision_normal2 = player.floor_raycast2.get_collision_normal()
		var normal_distance = (floor_collision_normal1 - floor_collision_normal2).length()
		different_collisions = normal_distance > 0.05
		if !different_collisions:
			player.rotation = lerp(player.rotation, player.floor_raycast.get_collision_normal().angle() + PI / 2, 0.5)
			player.floor_raycast.rotation = -player.rotation
			player.floor_raycast2.rotation = -player.rotation
	
	if !player.floor_raycast.is_colliding() and !player.floor_raycast2.is_colliding():
		player.rotation = 0
		player.floor_raycast.rotation = 0
		player.floor_raycast2.rotation = 0


# Returns direction of Wall via WALL_DIRECTION Enum if player is pressed against a wall
func get_wall_press_state():
	var direction = Input.get_axis("left", "right")
	if player.l_up_wall_raycast.is_colliding() and player.l_down_wall_raycast.is_colliding():
		if direction < 0: 
			return Enums.WALL_DIRECTION.LEFT
	elif player.r_up_wall_raycast.is_colliding() and player.r_down_wall_raycast.is_colliding():
		if direction > 0:
			return Enums.WALL_DIRECTION.RIGHT

	return Enums.WALL_DIRECTION.NONE

# Returns direction of Wall via WALL_DIRECTION Enum if player is standing next to a wall
func get_wall_direction():
	if player.is_on_wall_only():
		var collision = player.get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			if normal.x > 0:  # Colliding with a wall on the right
				return Enums.WALL_DIRECTION.LEFT
			elif normal.x < 0:  # Colliding with a wall on the left
				return Enums.WALL_DIRECTION.RIGHT
	
	return Enums.WALL_DIRECTION.NONE
	
