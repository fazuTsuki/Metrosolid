class_name combat_manager
extends Node

enum enum_status {start, in_the_joke}
var joke_status: enum_status = enum_status.start

var queue_idea: Array[PlayerIdea]

func set_up(player:playerStats,idea: PlayerIdea, enemy: EnemyStats):
	var engagement: float = idea.engagement_from_idea()
	engagement *= queue_multiply()
	enemy.inject_engagement(idea,engagement)
	queue_idea.append(idea)

func meander(player:playerStats,idea: PlayerIdea, enemy: EnemyStats):
	var engagement: float = idea.engagement_from_idea()
	engagement *= queue_multiply()
	enemy.inject_engagement(idea,engagement)
	queue_idea.append(idea)
	
func punchline(player:playerStats,idea: PlayerIdea, enemy: EnemyStats):
	var engagement: float
	var haha: float
	if enemy.engagement.current_points >= enemy.engagement_threshhold:
		player.happy_points.add_points(enemy.engagement.current_points)
		engagement = idea.engagement_from_idea()
		haha = idea.haha_from_idea()
		engagement *= queue_multiply()
		haha *= queue_multiply()
		enemy.inject_engagement(idea,engagement)
		enemy.inject_haha(idea,haha)
	elif enemy.engagement.current_points < enemy.engagement_threshhold:
		player.happy_points.deduct_points((enemy.engagement_threshhold - enemy.engagement.current_points)*queue_multiply())
		enemy.engagement.deduct_points(enemy.engagement.current_points * (enemy.engagement.current_points/enemy.engagement_threshhold))
	player.act += player.happy_points.percentage() * 10
	queue_idea.clear()

func queue_multiply():
	return 1 + (queue_idea.size()*0.1)

