extends Node2D

@onready var player = $CharacterParent/Player
@onready var respawn = $RespawnMarker
@onready var checkpoints = $Checkpoints
@onready var anim_player = $AnimationPlayer
func _ready():
	player.player_died.connect(_on_player_died)

func _on_killboxes_body_entered(body):
	reset()
func _on_player_died():
	reset()
	
func reset():
	anim_player.play("fade_to_black")
	player.respawn(respawn)



func _on_checkpoints_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	respawn.global_position = checkpoints.get_child(local_shape_index).global_position
	#TODO NOT WORKING
	var checkpoint = checkpoints.get_child(local_shape_index)
	checkpoint.set_deferred("disabled", true)
