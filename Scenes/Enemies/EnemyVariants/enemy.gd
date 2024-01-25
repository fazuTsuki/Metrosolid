'''
Generic Enemey class
Every enemy should be a scene variant of this
'''
class_name Enemy
extends CharacterBody2D

@export var enemy_stats: EnemyStats

var facing_dir : FacingDirection.FACE :
	set(value):
		if facing_dir != value:
			facing_dir = value
			# Animparam here


func _ready():
	pass

func update_direction(dir : Vector2):
	if dir != Vector2.ZERO:
		if abs(dir.y) > abs(dir.x):
			facing_dir = FacingDirection.FACE.UP if dir.y < 0 else FacingDirection.FACE.DOWN
		else:
			facing_dir = FacingDirection.FACE.RIGHT if dir.x > 0 else FacingDirection.FACE.LEFT
