'''
Resource used to contains data
about a player's skill.
used for combat
'''
class_name PlayerSkill
extends Resource

enum TYPE{
	SET_UP,
	MEANDER,
	PUNCH_LINE
}
	
@export var name : String
@export var type : TYPE
@export var joke_type : Ticklebone.TYPE
@export var engagament_point : float
@export var haha_point : float

var level : int = 1 :
	set(value):
		var delta = abs(level - value)
		if delta != 0:
			level = value
			engagament_point *= (0.25 * delta) * (1 if delta > 0 else -1)
			haha_point *= (0.25 * delta) * (1 if delta > 0 else -1)

