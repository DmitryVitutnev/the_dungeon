extends Node2D

# Speed is in tiles per second
const MOVE_SPEED = 5


var working : bool setget ,_is_working


var _actor := []
var _start_point := []
var _end_point := []
var _t := []
var _delta_t := []


func _process(delta) -> void:
	for i in range(_actor.size() - 1, -1, -1):
		if _t[i][0] + _delta_t[i][0] * delta >= 1:
			_actor[i].position = _end_point[i][0]
			_start_point[i].remove(0)
			_end_point[i].remove(0)
			_t[i].remove(0)
			_delta_t[i].remove(0)
			if _start_point[i].size() == 0:
				_actor[i].in_animation = false
				_actor.remove(i)
				_start_point.remove(i)
				_end_point.remove(i)
				_t.remove(i)
				_delta_t.remove(i)
		else:
			_t[i][0] += _delta_t[i][0] * delta
			_actor[i].position = (1 - _t[i][0]) * _start_point[i][0] + _t[i][0] * _end_point[i][0]


func move_actor(actor : Actor, target : Vector2) -> void:
	if !_actor.has(actor):
		_actor.append(actor)
		actor.in_animation = true
		_start_point.append([])
		_end_point.append([])
		_t.append([])
		_delta_t.append([])
	var index = _actor.find(actor)
	_start_point[index].append(actor.pos * 32)
	_end_point[index].append(target * 32)
	_t[index].append(0.0)
	var distance := (_end_point[index].back() - _start_point[index].back()).length() as float
	_delta_t[index].append(actor.speed * 32 / distance)


func clear() -> void:
	_actor.clear()
	_start_point.clear()
	_end_point.clear()
	_t.clear()
	_delta_t.clear()


func _is_working() -> bool:
	return _actor.size() > 0
