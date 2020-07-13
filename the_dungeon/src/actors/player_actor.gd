extends Actor
class_name PlayerActor


var _is_my_turn := false
var _movement_queue := []


func _process(delta):
	if _is_my_turn and !in_animation and !_movement_queue.empty():
		var actor := _actor_list.get_alive_actor_by_pos(_movement_queue[0]) as Actor
		if actor != null:
			_is_my_turn = false
			_movement_queue.clear()
			emit_signal("action_attack", self, actor, _get_damage())
		else:
			_is_my_turn = false
			var target_pos = _movement_queue[0]
			_movement_queue.remove(0)
			emit_signal("action_move", self, target_pos)


func start_turn() -> void:
	_is_my_turn = true


func handle_input(event : InputEvent) -> void:
	if !_is_my_turn or _get_health() <= 0:
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
				emit_signal("action_move", self, target_pos)
			else:
				emit_signal("action_attack", self, actor, _get_damage())
			return
	
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		var click_pos := _map.coord_to_pos(get_global_mouse_position())
		var path := _map.find_path(pos, click_pos)
		if path[path.size() - 1] == click_pos and path.size() > 1:
			_movement_queue.clear()
			for i in range(1, path.size()):
				_movement_queue.append(path[i])
			return
		

