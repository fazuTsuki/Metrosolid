class_name StateMachine
extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioning.connect(StateTransition)
	if initial_state : current_state = initial_state
	

func StateTransition(state_name : StringName):
	if current_state:
		var next_state = states.get(state_name.to_lower())
		if !next_state : return
		current_state.Exit()
		current_state = next_state
		current_state.Enter()
	else: 
		if initial_state : current_state = initial_state
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if current_state:
		current_state.update(delta)

func physics_update(delta):
	if current_state:
		current_state.physics_Update(delta)
