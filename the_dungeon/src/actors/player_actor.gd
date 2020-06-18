extends Actor
class_name PlayerActor


signal player_health_changed(new_health)


var _health := 3
var _is_my_turn := false


func _input(event) -> void:
	if !_is_my_turn:
		print("Not my turn")
		return
	var movement := Vector2.ZERO
	if event.is_action_pressed("left"):
		movement = Vector2(-1, 0)
	if event.is_action_pressed("right"):
		movement = Vector2(1, 0)
	if event.is_action_pressed("up"):
		movement = Vector2(0, -1)
	if event.is_action_pressed("down"):
		movement = Vector2(0, 1)
	if movement != Vector2.ZERO:
		_is_my_turn = false
		if _map.is_free(pos + movement):
			var actor = _actor_list.get_actor_by_pos(pos + movement)
			if actor == null:
				emit_signal("move", movement, 1)
			else:
				emit_signal("attack", actor, 1, 1)
		else:
			emit_signal("idle", 1)
	


func start_turn() -> void:
	_is_my_turn = true


func take_damage(amount : int) -> void:
	_health -= amount
	print(_health)
	emit_signal("player_health_changed", _health)
