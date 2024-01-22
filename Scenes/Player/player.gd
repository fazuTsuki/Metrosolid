class_name Player
extends CharacterBody2D

@export var speed : float = 600

func moving():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() *  speed
	
	move_and_slide()

func _process(delta):
	%StateMachine.update(delta)
	
func _physics_process(delta):
	%StateMachine.physics_update(delta)
