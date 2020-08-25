extends Node2D
class_name ActorList


"""
In this script types are not specified because Godot 3.2 does not support cyclic 
dependencies and this script is meant to be used so that actors will know about 
each other. I hope that this problem will be fixed in the future updates of Godot 
engine. I will specify types in this script then.
"""


var player # : PlayerActor
var _enemies := []


func add_enemy(enemy) -> void:
	_enemies.push_back(enemy)
	add_child(enemy)


func remove_enemy(enemy) -> void:
	_enemies.erase(enemy)
	remove_child(enemy)


func get_alive_actor_by_pos(pos : Vector2):
	if player.pos == pos:
		return player
	for i in range(_enemies.size()):
		if _enemies[i].pos == pos and _enemies[i].health > 0:
			return _enemies[i]
	return null


func get_all_actors_by_pos(pos : Vector2):
	var result := []
	if player.pos == pos:
		result.append(player)
	for i in range(_enemies.size()):
		if _enemies[i].pos == pos:
			result.append(_enemies[i])
	return result


func get_all() -> Array:
	return [player] + _enemies


func get_all_alive() -> Array:
	var result := []
	if player.health > 0:
		result.append(player)
	for i in range(_enemies.size()):
		if _enemies[i].health > 0:
			result.append(_enemies[i])
	return result


func clear_enemies() -> void:
	var enemies_to_remove := [] + _enemies
	for enemy in enemies_to_remove:
		remove_enemy(enemy)
