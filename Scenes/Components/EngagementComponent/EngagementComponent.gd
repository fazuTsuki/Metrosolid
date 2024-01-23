'''
Child of Generic Point Component
A more specific point system for engagement  stat
'''
class_name EngagementComponent
extends GenericPointComponent

enum STATUS{
	BORED,
	NORMAL,
	LAUGH
}

#A Signal when the status changed, duh
signal status_changed

var current_status : STATUS = STATUS.BORED :
	set(value):
		if value != current_status:
			current_status = value
			status_changed.emit()

func add_points(delta : float):
	if delta != 0 :
		points_added.emit() if delta > 0 else points_deducted.emit()
		current_points = clampf(current_points + delta, min_point, max_point)
		
		if current_points == max_point : points_full.emit() 
		elif current_points == min_point : points_depleted.emit()
		
		# < 60% = bored; >60% and <100% = normal; 100% = laugh
		if current_points <= 0.6 : current_status = STATUS.BORED
		elif current_points > 0.6 and current_points < 1 : current_status = STATUS.NORMAL
		else : current_status = STATUS.LAUGH
