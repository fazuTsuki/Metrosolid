extends Node2D

@onready var player = $Player

func _ready():
	player.player_stats = GameManager.player_stats
