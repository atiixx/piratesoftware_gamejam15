extends Node2D

@onready var player = $CharacterParent/Player
@onready var checkpoints = $Checkpoints
@onready var anim_player = $AnimationPlayer
var boss_spawn_marker 
var boss_door_open_pos 
var boss_door_closed_pos 
@onready var killboxes = $Killboxes
var boss
var was_at_boss = false

var boss_trigger

signal level_one_finished()

func _ready():
	if has_node("CharacterParent/RangedBoss"):
		boss = $CharacterParent/RangedBoss
	if has_node("BossFightTrigger"):
		boss_trigger= $BossFightTrigger
	if has_node("BossSpawnMarker"):
		boss_spawn_marker = $BossSpawnMarker
	if has_node("BossDoorPositionOpen"):
		boss_door_open_pos = $BossDoorPositionOpen
	if has_node("BossDoorPositionClosed"):
		boss_door_closed_pos = $BossDoorPositionClosed
	if boss:
		boss.boss_died.connect(_on_boss_died)



func _on_boss_died():
	level_one_finished.emit()
	boss.queue_free()

	
	
func _on_checkpoints_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	SpawnPoint.current_position = checkpoints.get_child(local_shape_index).global_position
	var checkpoint = checkpoints.get_child(local_shape_index)
	checkpoint.set_deferred("disabled", true)


func _on_boss_fight_trigger_body_entered(body):
	was_at_boss = true
	var boss = $CharacterParent/RangedBoss
	var boss_door = $Map/BossDoor
	var tween = create_tween()
	tween.tween_property(boss_door, "global_position:y", boss_door.global_position.y + 400, 1)
	if body.get_collision_layer_value(2):
		boss.start_fight()
		boss_trigger.get_child(0).call_deferred("set_disabled", true) 
