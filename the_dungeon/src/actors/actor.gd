extends Node2D
class_name Actor


signal move(dir, delay)
signal attack(target, damage, delay)
signal death(actor)


var pos : Vector2


var _map : Map
var _actor_list : ActorList


func initialize(pos : Vector2, map : Map, actor_list : ActorList) -> void:
	self.pos = pos
	position = pos * 32
	_map = map
	_actor_list = actor_list


func start_turn() -> void:
	pass


func take_damage(amount : int) -> void:
	pass
