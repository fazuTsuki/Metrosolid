extends Enemy

const unhappy_enemy_potrait = "res://Assets/Enemy/enemy_potrait.png"
const happy_enemy_potrait = "res://Assets/Enemy/happy_enemy_potrait.png"

func _ready():
	super._ready()
	set_state()

func set_state():
	var player_level = GameManager.player_stats.level
	enemy_stats = EnemyStats.new(clamp(player_level + randi_range(-1,1),1,1000))
	enemy_stats.unhappy_potrait_combat = load(unhappy_enemy_potrait)
	enemy_stats.happy_potrait_combat = load(happy_enemy_potrait)


func _physics_process(delta):
	animation_tree["parameters/conditions/idle"] = false
	animation_tree["parameters/conditions/is_moving"] = true
	if facing_dir == FacingDirection.FACE.DOWN:
		animation_tree["parameters/walk/blend_position"] = Vector2.DOWN
	elif facing_dir == FacingDirection.FACE.UP:
		animation_tree["parameters/walk/blend_position"] = Vector2.UP
	elif facing_dir == FacingDirection.FACE.LEFT:
		animation_tree["parameters/walk/blend_position"] = Vector2.LEFT
	elif facing_dir == FacingDirection.FACE.RIGHT:
		animation_tree["parameters/walk/blend_position"] = Vector2.RIGHT
	pass
