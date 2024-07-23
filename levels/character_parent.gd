extends Node2D

@onready var player: CharacterBody2D = find_child("Player")
@onready var boss: CharacterBody2D = find_child("RangedBoss")
# Called when the node enters the scene tree for the first time.
func _ready():
	player.enemy_hit.connect(_on_enemy_hit)
	boss.player_hit.connect(_on_player_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_hit(body: Node2D):
	var enemy = find_child(body.name)
	if enemy and enemy.has_method("get_hit"):
		enemy.get_hit()

func _on_player_hit(body: Node2D):
	var hit_player = find_child(body.name)
	if hit_player and hit_player.has_method("get_hit"):
		hit_player.get_hit()
