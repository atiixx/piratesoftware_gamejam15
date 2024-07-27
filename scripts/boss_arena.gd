extends Node2D

signal player_entered_boss_arena()

@onready var boss = $CharacterParent/RangedBoss
@onready var boss_trigger = $Map/BossFightTrigger
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_boss_fight_trigger_body_entered(body):
	if body.get_collision_layer_value(2):
		boss.start_fight()
		boss_trigger.get_child(0).call_deferred("set_disabled", true) 
