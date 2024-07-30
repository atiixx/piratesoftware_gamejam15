extends Node2D

@onready var player = $CharacterParent/Player
@onready var respawn = $RespawnMarker
@onready var checkpoints = $Checkpoints
@onready var anim_player = $AnimationPlayer
@onready var boss_trigger= $BossFightTrigger
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
	var checkpoint = checkpoints.get_child(local_shape_index)
	checkpoint.set_deferred("disabled", true)


func _on_boss_fight_trigger_body_entered(body):
	var boss = $CharacterParent/RangedBoss
	var boss_door = $Map/BossDoor
	var tween = create_tween()
	tween.tween_property(boss_door, "position", Vector2(0, 100), 1)
	if body.get_collision_layer_value(2):
		boss.start_fight()
		boss_trigger.get_child(0).call_deferred("set_disabled", true) 
