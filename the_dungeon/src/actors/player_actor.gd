extends Actor
class_name PlayerActor


var _is_my_turn := false


func _input(event) -> void:
	if !_is_my_turn:
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
				emit_signal("move", movement, stats.recovery_delay)
				#print(stats.recovery_delay)
			else:
				emit_signal("attack", actor, stats.damage, stats.recovery_delay)
		else:
			emit_signal("idle", stats.recovery_delay)
	


func start_turn() -> void:
	_is_my_turn = true
