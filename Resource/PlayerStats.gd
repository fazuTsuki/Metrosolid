extends Resource
class_name playerStats

const JOKE_MATERIAL_PATH = "res://Resource/Material/"

signal signal_level_up

@export var level: int
@export var max_happy_points : float = 100 :
	set(value):
		max_happy_points = value 
		if happy_points:
			happy_points.max_points = value
			happy_points.reset_points()
@export var act: int
@export var starting_act: int = 10
@export var flat_exp:float
@export var max_flat_exp:float

var materials: Array[JokeMaterial] = []
var happy_points: GenericPointSystem
var exp: GenericPointSystem 

func _init():
	happy_points = GenericPointSystem.new()
	exp = GenericPointSystem.new()
	
	happy_points.reset_to_min = false
	
	load_joke_materials()

func load_joke_materials():
	
	var set_up_dir = DirAccess.open("res://Resource/Materials/SetUp/")
	var meander_dir = DirAccess.open("res://Resource/Materials/Meander/")
	var punchline_dir = DirAccess.open("res://Resource/Materials/PunchLine/")
	
	if set_up_dir:
		for set_up in set_up_dir.get_files():
			if set_up.contains(".tres"):
				materials.append(load("res://Resource/Materials/SetUp/" + set_up))
	
	if meander_dir:
		for meander in meander_dir.get_files():
			if meander.contains(".tres"):
				materials.append(load("res://Resource/Materials/Meander/" + meander))
	
	if punchline_dir:
		for punchline in punchline_dir.get_files():
			if punchline.contains(".tres"):
				materials.append(load("res://Resource/Materials/PunchLine/" + punchline))
	

func exp_up(exp):
	flat_exp += exp
	self.exp.add_points(exp)
	while flat_exp >= max_flat_exp:
		level_up(flat_exp - max_flat_exp)

var position_in_overworld : Vector2

func reset_act():
	act = starting_act

func level_up(exp_remainder: float):
	level += 1
	happy_points.max_points += 10
	var isLevelEven = int(level % 2 == 0)
	starting_act += 1 * isLevelEven
	exp.max_points *= 2
	max_flat_exp += exp.max_points
	exp.current_points = exp_remainder
	for material in materials:
		material.check_player_level(level)
	signal_level_up.emit()
