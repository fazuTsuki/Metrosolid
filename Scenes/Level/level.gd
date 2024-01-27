class_name Level
extends Node2D

@onready var player_spawn_loc : Vector2 = %SpawnAnchor.global_position
@onready var player_scene : PackedScene = preload("res://Scenes/Player/player.tscn") 

var player : Player

func _ready():
	global_position = Vector2.ZERO
	player = player_scene.instantiate()
	player.player_stats = GameManager.player_stats
	if GameManager.latest_player_pos:
		player.global_position = GameManager.latest_player_pos
	else:
		player.global_position = player_spawn_loc
	
	add_child(player)
	
	%PhantomCamera2D.set_follow_target_node(player)
	
