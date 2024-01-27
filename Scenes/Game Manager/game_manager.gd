extends Node

@onready var player_stats: playerStats = preload("res://Scenes/Game Manager/default_player_stats.tres")

@onready var packed_combat_scene: PackedScene = preload("res://Scenes/Combat/combat_scene.tscn")

var overworld_saved: PackedScene

func change_scene_to_combat(overworld, enemy_stats):
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
	
func chnage_to_overworld():
	if overworld_saved:
		var overworld_scene = overworld_saved.instantiate()
		get_tree().root.add_child(overworld_scene)
		var old_scene = get_tree().current_scene
		get_tree().current_scene = overworld_scene
		old_scene.free()
	else:
		pass
