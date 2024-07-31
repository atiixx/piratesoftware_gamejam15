extends Marker2D

func _ready():
	if SpawnPoint.current_position != Vector2.ZERO:
		global_position = SpawnPoint.current_position
