extends Node2D
class_name Actor


signal move(dir)


var pos : Vector2


var _map : Map


func initialize(pos : Vector2, map : Map):
	self.pos = pos
	position = pos * 32
	_map = map


func start_turn():
	print("Hello!!!!!")
