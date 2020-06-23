extends Node2D
class_name Actor


signal idle(delay)
signal move(dir, delay)
signal attack(target, damage, delay)
signal health_changed(new_health)
signal death(actor)


export var starting_stats : Resource


var pos : Vector2


var _map : Map
var _actor_list : ActorList


onready var stats := $Stats as ActorStats
onready var sound := $Sound as ActorSound


func initialize(map : Map, actor_list : ActorList) -> void:
	stats.initialize(starting_stats)
	_map = map
	_actor_list = actor_list


func set_pos(new_pos : Vector2) -> void:
	pos = new_pos
	position = pos * 32


func start_turn() -> void:
	pass


func take_damage(damage : int) -> void:
	stats.take_damage(damage)
	if stats.health <= 0:
		sound.play_kill()
		get_parent().move_child(self, 0) # Temporal solution
		emit_signal("death", self)
	else:
		sound.play_hit()
