'''
Resource used to contains data
about a player's skill.
used for combat
'''
class_name PlayerIdea
extends Resource


@export var name : String
@export var type : idea_type.TYPE
@export var joke_type : Array[type_of_joke.TYPE]
@export var haha_strength : float
@export var engagement_strength: float
@export var level : int = 1

@export_category("constant")
@export var level_constant: float = 0.1

#engagement
func engagement_from_idea() -> float:
	return engagement_strength * level_multiply()

#haha_strength
func haha_from_idea() -> float:
	return haha_strength * level_multiply()

func level_multiply() -> float:
	return 1 + (level * level_constant)
