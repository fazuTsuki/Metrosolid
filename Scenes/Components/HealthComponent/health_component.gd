'''
A component about health system

Might be deprecated in later version
'''
class_name HealthComponent
extends Node

@export var max_health : float = 100

@onready var current_health : float = max_health

var alive : bool = true
var full : bool = true
 
#region Signals
# all health has been depleted
signal health_depleted

#current health's value have decreased
signal health_decreased

#current health's value have increased
signal health_added

#signal when the health is full
signal full_health

#endregion

func reset_current_health():
	current_health = max_health
	full = true

func add_health(delta : float):
	if alive:
		current_health = clampf(current_health + delta, 0, max_health)
		
		alive = current_health > 0
		if !alive:
			health_depleted.emit()
		elif delta > 0:
			health_added.emit()
		full = current_health == max_health
		if full: full_health.emit()

func take_damage(value : float):

	add_health(-value)
	health_decreased.emit()
