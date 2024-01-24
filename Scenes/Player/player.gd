class_name Player
extends CharacterBody2D

@export var player_stats: playerStats
@export var speed : float = 600
var enemy_in_interacted_area

func moving():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() *  speed
	move_and_slide()

func _process(delta):
	%StateMachine.update(delta)
	
func _physics_process(delta):
	%StateMachine.physics_update(delta)

func _input(event):
	if event.is_action_pressed("confirm") && enemy_in_interacted_area != null:
		var combat_scene = load("res://Scenes/Combat/combat_scene.tscn")
		combat_scene.player_stats = player_stats
		combat_scene.enemy_stats = enemy_in_interacted_area.enemy_stats
		get_tree().change_scene_to_packed(combat_scene)

func _on_interacted_area_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		enemy_in_interacted_area = area.get_parent()

func _on_interacted_area_area_exited(area):
	if area.get_parent().is_in_group("enemy"):
		enemy_in_interacted_area = null
