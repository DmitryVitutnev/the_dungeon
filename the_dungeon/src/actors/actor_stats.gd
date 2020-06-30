extends Node2D
class_name ActorStats


signal health_changed(new_health)


var max_health : int
var damage : String
var armor : int
var speed : int


func initialize(starting_stats : StartingStats) -> void:
	max_health = starting_stats.max_health
	damage = starting_stats.damage
	armor = starting_stats.armor
	speed = starting_stats.speed

