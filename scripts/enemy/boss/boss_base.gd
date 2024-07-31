extends CharacterBody2D
class_name Boss

@onready var player: CharacterBody2D = get_parent().find_child("Player")
@onready var boss_state_machine = $BossStateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var characters: Node2D = get_parent()
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var boss_health = $CanvasLayer/Container/ProgressBar
@onready var sprite := $Sprite2D
@onready var audio_streamer = $AudioStreamer
@onready var hurtbox = $Hurtbox
var getting_hit = false
var health: int = 5

signal boss_died()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hit():
	getting_hit = true
	audio_streamer.get_node("HurtSound").play()
	sprite.play("HURT")
	health -= 1
	boss_health.value = health
	if health == 0:
		die()
	await get_tree().create_timer(0.2).timeout
	getting_hit = false
		
func die():
	player.unlock_shooting()
	velocity = Vector2.ZERO
	boss_state_machine.transition_to("Idle")
	collision_shape.set_deferred("disable", true)
	hurtbox.set_deferred("monitoring", false)
	sprite.stop()
	sprite.play("DEATH")
	sprite.animation_finished.connect(func(): boss_died.emit())
	
	
