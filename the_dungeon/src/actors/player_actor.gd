extends Actor
class_name PlayerActor


var _is_my_turn := false
var _movement_queue := []


func _process(delta):
	if _is_my_turn and !in_animation and !_movement_queue.empty():
		_is_my_turn = false
		var actor := _actor_list.get_alive_actor_by_pos(_movement_queue[0]) as Actor
		if actor != null:
			_movement_queue.clear()
			emit_signal("action_attack", self, _weapon.attack_cost, actor, _get_damage())
		else:
			if _weapon is RangedWeaponItem:
				var ranged = _weapon as RangedWeaponItem
				for i in range(_movement_queue.size() - 1, 0, -1):
					var target_actor = _actor_list.get_alive_actor_by_pos(_movement_queue[i])
					if target_actor != null and _map.line_is_free(pos, _movement_queue[i]):
						_movement_queue.clear()
						emit_signal("action_shoot", self, ranged.attack_cost, target_actor, _get_damage(), ranged.projectile_scene)
						return
			
			var target_pos = _movement_queue[0]
			_movement_queue.remove(0)
			emit_signal("action_move", self, MOVEMENT_COST, target_pos)


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
				emit_signal("action_move", self, MOVEMENT_COST, target_pos)
			else:
				emit_signal("action_attack", self, _weapon.attack_cost, actor, _get_damage())
			return
	
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		var click_pos := _map.coord_to_pos(get_global_mouse_position())
		
		#var target_actor := _actor_list.get_alive_actor_by_pos(click_pos) as Actor
		#if target_actor != null and target_actor != self and _map.line_is_free(pos, target_actor.pos):
		#	if _weapon is RangedWeaponItem:
		#		var ranged := _weapon as RangedWeaponItem
		#		var projectile_scene = ranged.projectile_scene
		#		emit_signal("action_shoot", self, _weapon.attack_cost, target_actor, _get_damage(), projectile_scene)
		#		return
		var path := _map.find_path(pos, click_pos)
		if path[path.size() - 1] == click_pos and path.size() > 1:
			_movement_queue.clear()
			for i in range(1, path.size()):
				_movement_queue.append(path[i])
			return
		

