class_name GenericPointComponent
'''
Generic class for any stats
'''
extends Node

@export var max_point : float = 100 :
	set(value):
		max_point = value
		if current_points > max_point:
			current_points = max_point
	get: return max_point

@export var min_point : float = 0 :
	set(value):
		min_point = value
		if current_points < min_point:
			current_points = min_point
	get : return min_point

@export var starting_value_max : bool = true

var current_points : float = 0

#region Signals

#A signal for when a point is added / value increased
signal points_added

#A signal for when a point is deducted/ value decreased
signal points_deducted

#A signal for when reaching maximum points / value
signal points_full

#A Signal for when reaching minimum points/ value
signal points_depleted
#endregion

func reset_points() : 
	current_points = max_point if starting_value_max else min_point

func add_points(delta : float):
	if delta != 0 :
		points_added.emit() if delta > 0 else points_deducted.emit()
		current_points = clampf(current_points + delta, min_point, max_point)
		
		if current_points == max_point : points_full.emit() 
		elif current_points == min_point : points_depleted.emit()
	
func deduct_point(delta : float):
	add_points(-delta)
	
func points_percentage() -> float :
	return (current_points - min_point) / (max_point - min_point)
