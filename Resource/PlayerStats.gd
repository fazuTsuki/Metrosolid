extends Resource
class_name playerStats

@export var level: GenericPointSystem
@export var happy_points: GenericPointSystem
@export var act: GenericPointSystem
@export var ideas: Array[PlayerIdea]


func reset_act():
	act.current_points = act.max_points

func level_up():
	level.add_points(1)
	happy_points.max_points += 10
	var isLevelEven = (int(level.current_points) % 2 == 0)
	act.max_points += 1 * !isLevelEven
