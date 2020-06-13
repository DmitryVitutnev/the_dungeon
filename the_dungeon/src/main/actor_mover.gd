extends Node2D
class_name ActorMover


signal finished()


# Speed is in tiles per second
var MOVE_SPEED = 5


var _actor := []
var _start_point := []
var _end_point := []
var _t := []
var _delta_t := []


func _process(delta) -> void:
	for i in range(_actor.size() - 1, -1, -1):
		var wr = weakref(_actor[i])
		if !wr.get_ref() or _t[i] + _delta_t[i] * delta >= 1:
			if wr.get_ref():
				_actor[i].position = _end_point[i]
			_actor.remove(i)
			_start_point.remove(i)
			_end_point.remove(i)
			_t.remove(i)
			_delta_t.remove(i)
		else:
			_t[i] += _delta_t[i] * delta
			_actor[i].position = (1 - _t[i]) * _start_point[i] + _t[i] * _end_point[i]


func move_actor(actor : Actor, target : Vector2) -> void:
	_actor.append(actor)
	_start_point.append(actor.pos * 32)
	_end_point.append(target * 32)
	_t.append(0.0)
	var distance := (_end_point.back() - _start_point.back()).length() as float
	_delta_t.append(MOVE_SPEED * 32 / distance)
