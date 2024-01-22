'''
Generic Enemey class
Every enemy should be a scene variant of this
'''
class_name Enemy
extends Node2D

#Collections of good humor
@export var ticklebones : Dictionary

#collections of bad humor
@export var cringebones : Dictionary

#unused as of ver 0.0.2
@export var engagement_rate : float = 0.1

#When Happy Points is full
var entertained : bool = false

func calculate_engagement(skill_type : Ticklebone.TYPE):
	if ticklebones.has(skill_type):
		%EngagementComponent.add_points(0.2)
	elif cringebones.has(skill_type):
		(%EngagementComponent as EngagementComponent).deduct_point(0.3)
	else:
		(%EngagementComponent as EngagementComponent).add_points(0.1)

func take_damage(skill : PlayerSkill):
	calculate_engagement(skill.type)
	var damage = skill.damage
	var final_damage = (damage - %ResistanceComponent.current_points) * damage_multiplier()
	%HappyPointsComponent.add_points(final_damage)
	
func damage_multiplier() -> float:
	var status = %EngagementComponent.current_status
	match status:
		EngagementComponent.STATUS.BORED:
			return 0.8
		EngagementComponent.STATUS.NORMAL:
			return 1
		EngagementComponent.STATUS.LAUGH:
			return 1.2
		_ : return 0.5


func _on_happy_points_component_points_full():
	entertained = true
