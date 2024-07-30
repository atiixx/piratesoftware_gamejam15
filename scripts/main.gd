extends Node

@onready var canvas_layer = $CanvasLayer
@onready var bgm_player: AudioStreamPlayer = $BGM

func _ready():
	var boss 
	if has_node("RangedBoss"):
		boss = get_node("RangedBoss")
	if boss:
		boss.change_theme.connect(_on_change_theme)
		
func _on_start_pressed():
	var scene = load("res://levels/level_1.tscn").instantiate()
	canvas_layer.set_deferred("visible", false)
	add_child(scene)

func _on_volume_changed(value:float):
	var min_db = -60
	var max_db = -25
	bgm_player.volume_db = value / 100 * (max_db - min_db) + min_db
	
func _on_change_theme():
	var stream = load("res://music/Boss_Theme_guitar.wav")
	bgm_player.stream = stream
