extends CharacterBody2D
class_name Boss

@onready var player: CharacterBody2D = get_parent().find_child("Player")
@onready var boss_state_machine = $BossStateMachine
@onready var characters: Node2D = get_parent()
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var boss_health = $CanvasLayer/Container/ProgressBar
@onready var sprite := $Sprite2D
var getting_hit = false
var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hit():
	getting_hit = true
	sprite.play("HURT")
	health -= 1
	boss_health.value = health
	if health == 0:
		die()
	await get_tree().create_timer(0.2).timeout
	getting_hit = false
		
func die():
	sprite.play("DEATH")
	sprite.animation_finished.connect(func(): queue_free())
	
