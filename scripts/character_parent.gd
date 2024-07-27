extends Node2D

@onready var player: CharacterBody2D = find_child("Player")
@onready var children: Array[Node] = get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	player.enemy_hit.connect(_on_enemy_hit)
	for child in children:
		if child != player and child.has_signal("player_hit"):
			child.player_hit.connect(_on_player_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_hit(body: Node2D):
	var enemy = find_child(body.name)
	if enemy and enemy.has_method("get_hit"):
		enemy.get_hit()

func _on_player_hit(from: Node2D):
	if player and player.has_method("get_hit"):
		player.get_hit(from)
