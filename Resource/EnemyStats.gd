extends Resource
class_name EnemyStats

@export var potrait_combat: Texture 

@export var level: int = 1
@export var engagement_threshhold: float = 1
@export var max_happy_points : float = 100 :
	set(value):
		max_happy_points = value
		if happy_points:
			happy_points.max_points = value

@export var max_engagement_points : float = 100 :
	set(value):
		max_engagement_points = value
		if engagement:
			engagement.max_points = value

@export var retention: float
@export var retention_constant: float = 0.01
@export var resistant: float
@export var resistant_constant: float = 0.01
@export var ticklebone: Array[type_of_joke.TYPE]
@export var cringebone: Array[type_of_joke.TYPE]

var happy_points: GenericPointSystem
var engagement: GenericPointSystem



func _init(level):
	self.level = level
	happy_points = GenericPointSystem.new()
	engagement = GenericPointSystem.new()
	
	happy_points.max_points = float((20 * level) + (randi_range(1,5*level)) - (randi_range(1,5*level)))
	engagement.max_points = float((20 * level) + (randi_range(1,10*level)) - (randi_range(1,10*level)))
	
	engagement_threshhold = (engagement.max_points * 0.1) + (2*level)
	
	retention = float((10 * level) + (randi_range(1,5*level)) - (randi_range(1,5*level)))
	resistant = float((10 * level) + (randi_range(1,5*level)) - (randi_range(1,5*level)))
	
	var rand_range = type_of_joke.TYPE.size() - 1
	ticklebone.append(randi_range(0,rand_range))
	cringebone.append(randi_range(0,rand_range))

func inject_engagement(idea: JokeMaterial, engagement_prior: float):
	var final_engagement = (-20*int(idea.type == idea_type.TYPE.PUNCH_LINE)) + engagement_prior * retention_filter() * detect_ticklebone(idea.joke_type) * detect_cringebone(idea.joke_type)
	engagement.add_points(final_engagement)

func inject_haha(idea: JokeMaterial, haha_prior: float):
	var final_haha = haha_prior * resistant_filter() * detect_ticklebone(idea.joke_type) * detect_cringebone(idea.joke_type) * engagement_multiply()
	happy_points.add_points(final_haha)

func engagement_multiply():
	return (1 + ((engagement.current_points - engagement_threshhold) * 0.01))

func retention_filter():
	return 1 - (retention * retention_constant * (1 - engagement.percentage()))

func resistant_filter():
	return 1 - (resistant * resistant_constant * (1 - engagement.percentage()))

func detect_ticklebone(types_of_joke: Array[type_of_joke.TYPE]) -> float:
	var tickle_count = 0
	for joke_type in types_of_joke:
		if ticklebone.has(joke_type):
			tickle_count += 1
	return 1 * (1+tickle_count)

func detect_cringebone(types_of_joke: Array[type_of_joke.TYPE]) -> float:
	var cringe_count: float = 0
	for joke_type in types_of_joke:
		if cringebone.has(joke_type):
			cringe_count += 1
	return 1.0 / (1.0+cringe_count)
