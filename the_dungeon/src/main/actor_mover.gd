extends Node2D
class_name ActorMover


signal finished()


# Speed is in tiles per second
var MOVE_SPEED = 5


var _is_active := false
var _actor: Actor
var _start_point: Vector2
var _end_point: Vector2
var _end_pos: Vector2
var _t: float
var _delta_t: float


func _process(delta) -> void:
	if _is_active:
		_t += _delta_t * delta
		if _t >= 1:
			_actor.pos = _end_pos
			_actor.position = _end_point
			_is_active = false
			emit_signal("finished")
			return
		_actor.position = (1 - _t) * _start_point + _t * _end_point


func move_actor(actor : Actor, target : Vector2) -> void:
	_actor = actor
	_start_point = actor.pos * 32
	_end_point = target * 32
	_end_pos = target
	_t = 0
	var distance := (_end_point - _start_point).length()
	_delta_t = MOVE_SPEED * 32 / distance
	_is_active = true
