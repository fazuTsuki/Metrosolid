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
@export var level : int = 1

