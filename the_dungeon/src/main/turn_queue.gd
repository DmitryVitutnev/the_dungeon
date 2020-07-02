extends Node2D
class_name TurnQueue


var _queue := []
var _current_time := 0.0
var _time_passed := 0.0


func push_actor_and_time(actor : Actor, delay_time):
	_queue.push_back([actor, _current_time + delay_time])
	for i in range(_queue.size() - 1, 1, -1):
		if _queue[i-1][1] > _queue[i][1]:
			var x = _queue[i-1]
			_queue[i-1] = _queue[i]
			_queue[i] = x


func get_current_actor():
	return _queue[0][0]


func next_turn(cur_delay : float):
	push_actor_and_time(_queue[0][0],  cur_delay)
	_queue.pop_front()
	_time_passed = _queue[0][1] - _current_time
	_current_time = _queue[0][1]


func remove_actor(actor : Actor):
	for i in range(_queue.size() - 1, -1, -1):
		if _queue[i][0] == actor:
			_queue.remove(i)


func clear() -> void:
	_queue = []
	_current_time = 0.0
	_time_passed = 0.0
