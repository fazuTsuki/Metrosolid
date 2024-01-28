extends Control



func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level/level.tscn")
	pass # Replace with function body.


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/Credits/Credits.tscn")
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
