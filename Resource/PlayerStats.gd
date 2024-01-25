extends Resource
class_name playerStats

@export var level: GenericPointSystem
@export var happy_points: GenericPointSystem
@export var act: int
@export var starting_act: int = 10
@export var ideas: Array[PlayerIdea]

var position_in_overworld : Vector2

func reset_act():
	act = starting_act

func level_up():
	level.add_points(1)
	happy_points.max_points += 10
	var isLevelEven = (int(level.current_points) % 2 == 0)
	starting_act += 1 * !isLevelEven
