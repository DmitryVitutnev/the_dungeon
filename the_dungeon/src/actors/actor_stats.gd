extends Node2D
class_name ActorStats


signal health_changed(new_health)


var health : int
var max_health : int
var damage : int
var attack : int
var defense : int
var speed : int
var recovery_delay : float


func initialize(starting_stats : StartingStats) -> void:
	max_health = starting_stats.max_health
	damage = starting_stats.damage
	attack = starting_stats.attack
	defense = starting_stats.defense
	speed = starting_stats.speed
	
	health = max_health
	recovery_delay = 1.0 / float(speed)


func take_damage(damage : int) -> void:
	health = max(0, health - damage)
	emit_signal("health_changed", health)
