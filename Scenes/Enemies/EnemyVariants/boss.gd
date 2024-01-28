extends Enemy

@onready var animation_player = $AnimationPlayer
const unhappy_enemy_potrait = "res://Assets/Enemy/boss potrait.png"
const happy_enemy_potrait = "res://Assets/Enemy/happy boss potrait.png"


func _ready():
	set_state()
	animation_player.play("idle")

func set_state():
	var player_level = GameManager.player_stats.level
	enemy_stats = EnemyStats.new(15)
	enemy_stats.engagement_threshhold = enemy_stats.engagement.max_points/2
	enemy_stats.unhappy_potrait_combat = load(unhappy_enemy_potrait)
	enemy_stats.happy_potrait_combat = load(happy_enemy_potrait)
