'''
Generic Enemey class
Every enemy should be a scene variant of this
'''
class_name Enemy
extends CharacterBody2D

#Collections of good humor
@export var ticklebones : Dictionary

#collections of bad humor
@export var cringebones : Dictionary

@export var level : int = 1

@export var engagaement_resistance : float

var level_up_max_hp_increase : float = 0.5

var level_up_max_engagement_increase : float = 0.2

var facing_dir : FacingDirection.FACE :
	set(value):
		if facing_dir != value:
			facing_dir = value
			# Animparam here

#region signals
#signal when the NPC is fully enterntained
signal entertained

#signal when the NPC received a cringy idea
signal received_cringe

#signal when the joke is sucesfull
signal joke_suceed

#signal when the joke failed
signal joke_failed

#signal when the joke is cringe
signal joke_cringe
#endregion

func _ready():
	%HappyPointsComponent.max_point *= level_up_max_hp_increase * level
	%EngagementComponent.max_point *= level_up_max_engagement_increase * level

func _physics_process(delta):
	pass

func calculate_engagement(skill : PlayerSkill):
	var type = skill.type
	var coefficient = 1.5 if type == PlayerSkill.TYPE.SET_UP else 1
	
	var delta_engagement = skill.engagament_point * coefficient
	if ticklebones.has(skill.joke_type):
		delta_engagement *= 1.2
	elif cringebones.has(skill.joke_type):
		received_cringe.emit()
		delta_engagement *= -0.5
		
	if delta_engagement > 0 :
		delta_engagement = clampf(delta_engagement - engagaement_resistance, 1, delta_engagement)
		
	%EngagementComponent.add_points(
		delta_engagement * (%EngagementComponent.points_percentage() if delta_engagement > 0 else 1)
		)

func take_skill(skill : PlayerSkill):
	calculate_engagement(skill)
	if skill.type == PlayerSkill.TYPE.PUNCH_LINE:
		var haha_point = skill.haha_point
		if cringebones.has(skill.joke_type):
			%HappyPointsComponent.deduct_point(haha_point)
			joke_cringe.emit(haha_point)
		else:
			if %EngagementComponent.check_treshold():
				haha_point *= 1.5 if ticklebones.has(skill.joke_type) else 1
				haha_point *= %EngagementComponent.points_percentage()
				joke_suceed.emit(haha_point)
			else:
				haha_point = clampf(
					(haha_point * %EngagementComponent.points_percentage()) - %EngagementComponent.treshold,
					1,
					haha_point
					)
				joke_failed.emit(haha_point) 
				
			%HappyPointsComponent.add_points(haha_point)

func update_direction(dir : Vector2):
	if dir != Vector2.ZERO:
		if abs(dir.y) > abs(dir.x):
			facing_dir = FacingDirection.FACE.UP if dir.y < 0 else FacingDirection.FACE.DOWN
		else:
			facing_dir = FacingDirection.FACE.RIGHT if dir.x > 0 else FacingDirection.FACE.LEFT


func _on_happy_points_component_points_full():
	entertained.emit()
