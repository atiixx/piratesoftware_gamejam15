extends CharacterBody2D
class_name Boss

@onready var player: CharacterBody2D = get_parent().find_child("Player")
@onready var boss_state_machine = $BossStateMachine
@onready var characters: Node2D = get_parent()
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var dmg_anim_player: AnimationPlayer = $DamageAnimationPlayer
var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hit():
	print(self, " got hit")
	health -= 1
	if dmg_anim_player:
		dmg_anim_player.play("got_hit")
	if health == 0:
		die()
		
func die():
	queue_free()
