class_name Enemy
extends Node2D

@export var ticklebone : Ticklebone.TYPE
@export var engagement_rate : float = 0.1

var entertained : bool = false

func calculate_engagement(skill_type : Ticklebone.TYPE):
	if ticklebone == skill_type:
		(%EngagementComponent as EngagementComponent).add_points(0.1)

func take_damage(skill : PlayerSkill):
	calculate_engagement(skill.type)
	var damage = skill.damage
	var final_damage = (damage - %ResistanceComponent.current_points) * damage_multiplier()
	%HappyPointsComponent.add_points(final_damage)
	
func damage_multiplier() -> float:
	var status = %EngagementComponent.current_status
	match status:
		(%EngagementComponent as EngagementComponent).STATUS.BORED:
			return 0.8
		(%EngagementComponent as EngagementComponent).STATUS.NORMAL:
			return 1
		(%EngagementComponent as EngagementComponent).STATUS.LAUGH:
			return 1.2
		_ : return 0.5


func _on_happy_points_component_points_full():
	entertained = true
