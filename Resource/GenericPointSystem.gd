class_name GenericPointSystem
extends  Resource

@export var max_points : float : 
	set(value):
		max_points = value
		if current_points > max_points:
			current_points = max_points

@export var min_points : float :
	set(value):
		min_points = value 
		if current_points < min_points:
			current_points = min_points

@export var current_points : float :
	set(value):
		current_points = clampf(value, min_points, max_points)
		if current_points == max_points : points_full.emit()
		elif current_points == min_points : points_empty.emit()

signal points_added

signal points_deducted

signal points_full

signal points_empty

func add_points(delta : float):
	if delta != 0:
		points_added.emit() if delta > 0 else points_deducted
		current_points += delta

func deduct_points(delta : float):
	add_points(-delta)

func percentage() -> float :
	return (current_points - min_points) / (max_points - min_points)
