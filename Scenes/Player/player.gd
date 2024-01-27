class_name Player
extends CharacterBody2D

@export var player_stats: playerStats
@export var speed : float = 400
var enemy_in_interacted_area
@onready var animation_tree = $AnimationPlayer/AnimationTree

func _ready():
	animation_tree.active = true

func moving():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() *  speed
	move_and_slide()
	return direction

func _process(delta):
	pass
	
func _physics_process(delta):
	var direction = moving()
	if direction == Vector2.ZERO:
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/idle"] = true
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction

func _input(event):
	if event.is_action_pressed("confirm") && enemy_in_interacted_area != null:
		GameManager.change_scene_to_combat(get_parent(), enemy_in_interacted_area.enemy_stats)
		

func _on_interacted_area_area_entered(area):
	if area.get_parent().is_in_group("enemy"):
		enemy_in_interacted_area = area.get_parent()
		

func _on_interacted_area_area_exited(area):
	if area.get_parent().is_in_group("enemy"):
		enemy_in_interacted_area = null
