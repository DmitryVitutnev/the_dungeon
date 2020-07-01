extends Actor
class_name PlayerActor


var _is_my_turn := false


func _input(event) -> void:
	if !_is_my_turn or dead:
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
		var target_pos = pos + movement
		if _map.is_free(target_pos):
			_is_my_turn = false
			var actor = _actor_list.get_alive_actor_by_pos(target_pos)
			if actor == null:
				emit_signal("action_move", target_pos, 1.0/_get_speed())
			else:
				emit_signal("action_attack", actor, _get_damage(), 1.0/_get_speed())
	


func start_turn() -> void:
	_is_my_turn = true
