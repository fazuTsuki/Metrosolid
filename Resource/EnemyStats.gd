extends Resource
class_name EnemyStats

@export var level: GenericPointSystem
@export var happy_points: GenericPointSystem
@export var engagement: GenericPointSystem
@export var engagement_threshhold: float
@export var retention: float
@export var retention_constant: float = 0.01
@export var resistant: float
@export var ticklebone: Array[type_of_joke.TYPE]
@export var cringebone: Array[type_of_joke.TYPE]

func final_engagement():
	
	pass

func retention_filter():
	return 1 - (retention * retention_constant * (1 - engagement.percentage()))

func detect_ticklebone(types_of_joke: Array[type_of_joke.TYPE]):
	for joke_type in types_of_joke:
		if ticklebone.has(joke_type):
			pass
	pass

func detect_cringebone(types_of_joke: Array[type_of_joke.TYPE]):
	for joke_type in types_of_joke:
		if cringebone.has(joke_type):
			pass
	pass
