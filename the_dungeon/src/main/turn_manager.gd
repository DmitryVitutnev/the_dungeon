extends Node2D


var _actors := []
var _energy := []
var _current_index := 0


func add_actor(actor : Actor) -> void:
	_actors.push_back(actor)
	_energy.push_back(0)


func end_turn(energy_loss : int) -> void:
	_energy[_current_index] -= energy_loss
	_next_turn()


func _next_turn() -> void:
	
