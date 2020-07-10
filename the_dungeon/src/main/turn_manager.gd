extends Node2D
class_name TurnManager


var _actors := []
var _energy := []
var _current_index := 0


func start() -> void:
	_next_turn()


func add_actor(actor : Actor) -> void:
	_actors.push_back(actor)
	_energy.push_back(0.0)


func end_turn(energy_loss : float) -> void:
	_energy[_current_index] -= energy_loss
	_next_turn()


func clear() -> void:
	_actors.clear()
	_energy.clear()
	_current_index = 0


func _next_turn() -> void:
	var current_actor := _actors[_current_index] as Actor
	while _energy[_current_index] < 0 or current_actor.dead:
		_current_index = (_current_index + 1) % _actors.size()
		current_actor = _actors[_current_index]
		if _current_index == 0:
			_add_energy()
	current_actor.start_turn()


func _add_energy() -> void:
	var min_time_part = -_energy[0] / _actors[0].speed
	var min_index := 0
	for i in range(_actors.size()):
		var time_part = -_energy[0] / _actors[0].speed
		if time_part < min_time_part:
			min_time_part = time_part
			min_index = i
			
	for i in range(_actors.size()):
		_energy[i] += min_time_part * _actors[i].speed
	_energy[min_index] = 0
