extends Resource
class_name playerStats

signal signal_level_up

@export var level: int
@export var happy_points: GenericPointSystem
@export var act: int
@export var starting_act: int = 10
@export var ideas: Array[PlayerIdea]
@export var exp: GenericPointSystem 
@export var flat_exp:float
@export var max_flat_exp:float


func exp_up(exp):
	flat_exp += exp
	self.exp.add_points(exp)
	while flat_exp >= max_flat_exp:
		level_up(flat_exp - max_flat_exp)

var position_in_overworld : Vector2

func reset_act():
	act = starting_act

func level_up(exp_remainder: float):
	level += 1
	happy_points.max_points += 10
	var isLevelEven = int(level % 2 == 0)
	starting_act += 1 * isLevelEven
	exp.max_points *= 2
	max_flat_exp += exp.max_points
	exp.current_points = exp_remainder
	for idea in ideas:
		idea.check_player_level(level)
	signal_level_up.emit()
