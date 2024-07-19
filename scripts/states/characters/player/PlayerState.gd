# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name PlayerState
extends StateBase

enum WALL_DIRECTION {
	NONE,
	LEFT,
	RIGHT
}
# Typed reference to the player node.
var player: Player
var wall_dash := false


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
		player.gravity = player.base_gravity * 2
	elif Input.is_action_just_released("down"):
		player.gravity = player.base_gravity
	
	#long and short jump
	if Input.is_action_just_pressed("jump"):
		player.gravity = player.base_gravity * 0.6
	elif Input.is_action_just_released("jump"):
		player.gravity = player.base_gravity

	var direction = Input.get_axis("left", "right")
	
	#remove control of player shortly after walldash for smoother walldash
	if wall_dash and player.velocity.y < player.jump_speed / 3:
		pass
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

# Returns direction of Wall via WALL_DIRECTION Enum if player is pressed against a wall
func get_wall_press_state():
	if player.is_on_wall_only():
		var collision = player.get_last_slide_collision()
		var direction = Input.get_axis("left", "right")
		if collision:
			var normal = collision.get_normal()
			if normal.x > 0 and direction < 0: 
				return WALL_DIRECTION.LEFT
			elif normal.x < 0 and direction > 0:  # Colliding with a wall on the left
				return WALL_DIRECTION.RIGHT
	
	return WALL_DIRECTION.NONE

# Returns direction of Wall via WALL_DIRECTION Enum if player is standing next to a wall
func get_wall_direction():
	if player.is_on_wall_only():
		var collision = player.get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			if normal.x > 0:  # Colliding with a wall on the right
				return WALL_DIRECTION.LEFT
			elif normal.x < 0:  # Colliding with a wall on the left
				return WALL_DIRECTION.RIGHT
	
	return WALL_DIRECTION.NONE
	
