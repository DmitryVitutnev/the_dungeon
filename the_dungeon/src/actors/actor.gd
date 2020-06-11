extends Node2D
class_name Actor


signal move(dir)


var pos : Vector2


var _map : Map
var _actor_list


func initialize(pos : Vector2, map : Map, actor_list : ActorList):
	self.pos = pos
	position = pos * 32
	_map = map
	_actor_list = actor_list


func start_turn():
	pass
