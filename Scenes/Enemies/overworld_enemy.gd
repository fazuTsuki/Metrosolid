'''
NOT a child of enemy nor a variant
an Enemy that roams in the overworld
can spawn enemy as well
'''
class_name OverworldEnemy
extends Path2D

@export var walk_speed : float = 200

#wether or not to destroy the enemy when reaching the end of the path
@export var destroy_on_end : bool = true

#wether or not the enemy to walk back when reach one of the end
@export var loop : bool = false 

#the path to the enemy or its variant secene
@export var enemy_type : String

@export var spawn_cooldown : float = 60

@onready var enemy = load(enemy_type)

var spawned_enemy 
var can_spawn : bool = true

func _ready():
	%SpawnTimer.wait_time = spawn_cooldown
	%PathFollow2D.rotates = false

func _process(delta):
	if can_spawn and spawned_enemy == null:
		spawn_enemy()
		
func _physics_process(delta):
	if spawned_enemy:
		var old_pos = %PathFollow2D.global_position
		%PathFollow2D.progress += walk_speed * delta
		if spawned_enemy.has_method("update_direction"):
			spawned_enemy.update_direction((%PathFollow2D.global_position - old_pos).normalized())
		
func spawn_enemy():
	#reset the path to the start
	(%PathFollow2D as PathFollow2D).progress = 0
	
	#setting up the enemy
	var new_enemy = enemy.instantiate()
	new_enemy.global_position = %PathFollow2D.global_position
	%PathFollow2D.add_child(new_enemy)
	new_enemy.tree_exited.connect(func() : %SpawnTimer.start())
	
	spawned_enemy = new_enemy
	can_spawn = false
	

func _on_spawn_timer_timeout():
	can_spawn = true
