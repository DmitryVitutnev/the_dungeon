extends Node2D
class_name ActorList


"""
In this script types are not specified because Godot 3.2 does not support cyclic 
dependencies and this script is meant to be used so that actors will know about 
each other. I hope that this problem will be fixed in the future updates of Godot 
engine. I will specify types in this script then.
"""


var _player # : PlayerActor
var _enemies := []


func add_enemy(enemy) -> void:
	_enemies.push_back(enemy)
	add_child(enemy)


func remove_enemy(enemy) -> void:
	_enemies.erase(enemy)
	remove_child(enemy)


func get_actor_by_pos(pos : Vector2):
	if _player.pos == pos:
		return _player
	for i in range(_enemies.size()):
		if _enemies[i].pos == pos:
			return _enemies[i]
	return null


func get_player():
	return _player


func set_player(player) -> void:
	_player = player


func get_all() -> Array:
	return [_player] + _enemies


func clear_enemies() -> void:
	var enemies_to_remove := [] + _enemies
	for enemy in enemies_to_remove:
		remove_enemy(enemy)
