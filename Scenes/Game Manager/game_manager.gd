class_name game_manager
extends Node

@onready var packed_overworld_scene = preload("res://Scenes/Level/level.tscn")
@onready var packed_combat_scene: PackedScene = preload("res://Scenes/Combat/combat_scene.tscn")

var player_stats: playerStats
var latest_player_pos : Vector2

var overworld_saved: PackedScene

func _ready():
	player_stats = ResourceLoader.load("res://Scenes/Game Manager/default_player_stats.tres")
	print_debug(player_stats.level)
	
func change_scene_to_combat(overworld, enemy_stats):
	player_stats = overworld.player.player_stats
	latest_player_pos = overworld.player.global_position
	
	var packed_overworld = PackedScene.new()
	packed_overworld.pack(overworld)
	overworld_saved = packed_overworld
	var combat_scene = packed_combat_scene.instantiate()
	
	combat_scene.player_stats = player_stats
	combat_scene.enemy_stats = enemy_stats
	
	get_tree().root.add_child(combat_scene)
	
	var old_scene = get_tree().current_scene
	get_tree().current_scene = combat_scene
	old_scene.free()
	
func change_to_overworld(player_stats : playerStats):
	self.player_stats = player_stats
	
	var overworld_scene = overworld_saved.instantiate() if overworld_saved else packed_overworld_scene.instantiate()
	
	get_tree().root.add_child(overworld_scene)
	
	var old_scene = get_tree().current_scene
	get_tree().current_scene = overworld_scene
	old_scene.free()
	
