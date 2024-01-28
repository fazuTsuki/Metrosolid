'''
NOT a child of enemy nor a variant
an Enemy that roams in the overworld
can spawn enemy as well
'''
class_name OverworldEnemy
extends Path2D

@export var walk_speed : float = 200

# wether or not to destroy the enemy when reaching the end of the path
@export var destroy_on_end : bool = true 

# wether or not the enemy to walk back when reach one of the end
# should be mutually exclusive with destoy on end
@export var back_and_forth : bool = false 

@export_category("Enemy")
#the path to the enemy or its variant secene
@export var enemy_type : PackedScene

@export var spawn_cooldown : float = 30

# add as a child of the node in the editor or else
@export var detection_area : Area2D 

# automatically added via code
@onready var path_follow : PathFollow2D = PathFollow2D.new()
@onready var spawn_timer : Timer = Timer.new()

# A flag to mark the end destination, uses Follow's ratio
var end_destination : int = 1

var spawned_enemy 
var can_spawn : bool = true
var player_nearby : bool 

func _get_configuration_warning() -> String:
	if not has_node("Area2D"):
		return "overworldEnemy requires an Area2D as its child."
	return ""

func _ready():
	# added as a child via code
	add_child(path_follow)
	add_child(spawn_timer)
	
	# setup 
	spawn_timer.wait_time = spawn_cooldown
	path_follow.loop = false
	path_follow.rotates = false
	path_follow.rotation = 0
	
	# Connecting to necessary signals
	spawn_timer.timeout.connect(func() : can_spawn = true)
	if detection_area:
		detection_area.body_entered.connect(func(body) : player_nearby = true)
		detection_area.body_exited.connect(func(body) : player_nearby = false)
	

func _process(delta):
	if can_spawn and player_nearby and spawned_enemy == null:
		spawn_enemy()
		
func _physics_process(delta):
	if spawned_enemy:
		# keep track the old pos for movement delta
		var old_pos = path_follow.global_position
		
		path_follow.progress += walk_speed * delta
		
		# update the enemy's facing direction
		if spawned_enemy.has_method("update_direction"):
			spawned_enemy.update_direction((path_follow.global_position - old_pos).normalized())
		
		# when the enemy reached the end of the path
		if path_follow.progress_ratio == end_destination:
			if destroy_on_end:
				spawned_enemy.queue_free()
				spawned_enemy = null
				
				spawn_timer.start()
			elif back_and_forth:
				# walk back to the start
				walk_speed *= -1
				end_destination = 0 if end_destination == 1 else 1
		
func spawn_enemy():
	#reset the path to the start
	path_follow.progress = 0
	#setting up the enemy
	var new_enemy = enemy_type.instantiate()
	get_parent().add_child(new_enemy)
	#setting up the remotetransform
	var enemy_node_path = new_enemy.get_path()
	var remote_transform = RemoteTransform2D.new()
	remote_transform.remote_path = enemy_node_path
	path_follow.add_child(remote_transform)
	
	spawned_enemy = new_enemy
	can_spawn = false
	
