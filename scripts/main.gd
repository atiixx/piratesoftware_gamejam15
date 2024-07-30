extends Node

func _on_start_pressed():
	get_tree().call_deferred("change_scene_to_file", "res://levels/level_1.tscn")

func _on_volume_changed(value:float):
	var min_db = -60
	var max_db = 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value / 100 * (max_db - min_db) + min_db)
