extends Node2D
class_name TurnQueue


var _units := []
var _queue := []
var _current_time := 0.0


func push_actor_and_time(actor : Actor, delay_time := 0):
	_queue.push_back([actor, _current_time + delay_time])
	for i in range(_queue.size() - 1, 1, -1):
		if _queue[i-1][1] > _queue[i][1]:
			var x = _queue[i-1]
			_queue[i-1] = _queue[i][1]
			_queue[i][1] = x


func pop_actor_and_time() -> void:
	_queue.pop_front()
	_current_time = _queue[0][1]
	
