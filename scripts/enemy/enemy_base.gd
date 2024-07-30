extends CharacterBody2D
class_name Enemy

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var enemy_state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var player: CharacterBody2D = get_parent().find_child("Player")
@onready var hurtbox = $Hurtbox


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 3

@onready var dmg_anim_player: AnimationPlayer =$DamageAnimationPlayer

signal player_hit(source)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_hit():
	if has_node("AudioStreamPlayer2D"):
		var audio = $AudioStreamPlayer2D
		audio.play()
	health -= 1
	if dmg_anim_player:
		dmg_anim_player.play("got_hit")
	if health == 0:
		die()
		
func die():
	collision_shape.set_deferred("disable", true)
	hurtbox.set_deferred("monitoring", false)
	await get_tree().create_timer(1.0).timeout
	queue_free()
