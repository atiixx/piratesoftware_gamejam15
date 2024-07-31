extends Node

@onready var canvas_layer = $CanvasLayer
@onready var bgm_player: AudioStreamPlayer = $BGM
var current_level
var scene
func _ready():
	pass

func _on_killboxes_body_entered(body):
	reset()
	
func _on_player_died():
	
	reset()
	
func reset():
	current_level.anim_player.play("fade_to_black")
	await get_tree().create_timer(0.6).timeout
	current_level.queue_free()
	current_level = scene.instantiate()
	await add_child(current_level)
	if current_level.player:
		current_level.player.player_died.connect(_on_player_died)
	current_level.level_one_finished.connect(_on_level_one_finished)
	current_level.killboxes.body_entered.connect(_on_killboxes_body_entered)
	
func _on_start_pressed():
	scene = load("res://levels/level_1.tscn")
	current_level = scene.instantiate()
	canvas_layer.set_deferred("visible", false)
	await add_child(current_level)
	if current_level.player:
		current_level.player.player_died.connect(_on_player_died)
	current_level.level_one_finished.connect(_on_level_one_finished)
	current_level.killboxes.body_entered.connect(_on_killboxes_body_entered)

func _on_volume_changed(value:float):
	var min_db = -60
	var max_db = -25
	bgm_player.volume_db = value / 100 * (max_db - min_db) + min_db
	
func _on_change_theme():
	var stream = load("res://music/Boss_Theme_guitar.wav")
	bgm_player.stream = stream

func _on_level_one_finished():
	current_level.queue_free()
	SpawnPoint.current_position = Vector2.ZERO
	scene = load("res://levels/level_2.tscn")
	current_level = scene.instantiate()
	await add_child(current_level)
	current_level.killboxes.body_entered.connect(_on_killboxes_body_entered)
