extends Resource
class_name EnemyStats

@export var level: int
@export var happy_points: GenericPointSystem
@export var engagement: GenericPointSystem
@export var engagement_threshhold: float
@export var retention: float
@export var retention_constant: float = 0.01
@export var resistant: float
@export var resistant_constant: float = 0.01
@export var ticklebone: Array[type_of_joke.TYPE]
@export var cringebone: Array[type_of_joke.TYPE]

func inject_engagement(idea: PlayerIdea, engagement_prior: float):
	print("inject engagement")
	var final_engagement = (-20*int(idea.type == idea_type.TYPE.PUNCH_LINE)) + engagement_prior * retention_filter() * detect_ticklebone(idea.joke_type) * detect_cringebone(idea.joke_type)
	print(engagement_prior)
	engagement.add_points(final_engagement)

func inject_haha(idea: PlayerIdea, haha_prior: float):
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
	var cringe_count = 0
	for joke_type in types_of_joke:
		if cringebone.has(joke_type):
			cringe_count += 1
	return 1 / (1+cringe_count)
