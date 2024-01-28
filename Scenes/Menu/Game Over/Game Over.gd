extends Control

func _ready():
	GameManager.latest_player_pos = Vector2.ZERO

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu/Main Menu.tscn")
