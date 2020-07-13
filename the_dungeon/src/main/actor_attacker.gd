extends Node2D


signal finished()

# Speed is in tiles per second
const MOVE_SPEED = 5


var working : bool setget ,_is_working


var _active := false
var _actor : Actor
var _start_point : Vector2
var _end_point : Vector2
var _t : float
var _delta_t : float


func _process(delta) -> void:
	if _active:
		if _t + _delta_t * delta >= 1:
			_active = false
			_actor.position = _start_point
			emit_signal("finished")
		else:
			_t += _delta_t * delta
			if _t <= 0.33:
				_actor.position = (1 - 3 * _t) * _start_point + 3 * _t * _end_point
			else:
				_actor.position = 1.5 * (_t - 0.33) * _start_point + (1 - 1.5 * (_t - 0.33)) * _end_point
			


func attack_actor(actor : Actor, target : Vector2) -> void:
	_active = true
	_actor = actor
	_start_point = actor.pos * 32
	_end_point = target * 32
	_t = 0.0
	var distance := (_end_point - _start_point).length() as float
	_delta_t = MOVE_SPEED * 32 / distance


func clear() -> void:
	_active = false


func _is_working() -> bool:
	return _actor.size() > 0
