extends Node2D
class_name ActorList


"""
In this script types are not specified because Godot 3.2 does not support cyclic 
dependencies and this script is meant to be used so that actors will know about 
each other. I hope that this problem will be fixed in the future updates of Godot 
engine. I will specify types in this script then.
"""


var _player # : PlayerActor
var _actors := []


func add(actor) -> void:
	_actors.push_back(actor)
	add_child(actor)


func remove(actor) -> void:
	_actors.erase(actor)
	remove_child(actor)


func get_actor_by_pos(pos : Vector2):
	for i in range(_actors.size()):
		if _actors[i].pos == pos:
			return _actors[i]
	return null


func get_player():
	return _player


func set_player(player) -> void:
	_player = player


func get_all() -> Array:
	return [] + _actors


func clear() -> void:
	_actors = []
