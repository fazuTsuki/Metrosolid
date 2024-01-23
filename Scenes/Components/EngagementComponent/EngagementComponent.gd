'''
Child of Generic Point Component
A more specific point system for engagement  stat
'''
class_name EngagementComponent
extends GenericPointComponent

@export var treshold : float = 20

var old_points : float

func add_points(delta : float):
	if delta != 0 :
		old_points = current_points
		points_added.emit() if delta > 0 else points_deducted.emit()
		current_points = clampf(current_points + delta, min_point, max_point)
		
		if current_points == max_point : points_full.emit() 
		elif current_points == min_point : points_depleted.emit()
	
func deduct_point(delta : float):
	add_points(-delta)

func check_treshold() -> bool :
	var result = current_points - old_points >= treshold
	old_points = 0
	return result
