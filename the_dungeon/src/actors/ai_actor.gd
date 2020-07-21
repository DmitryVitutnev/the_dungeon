extends Actor


var _saw_player := false
var _last_seen_player_pos : Vector2


onready var _health_bar := $HealthBar as HealthBar


func initialize(map : Map, actor_list : ActorList) -> void:
	.initialize(map, actor_list)
	_health_bar.initialize(self)
	connect("stats_changed", _health_bar, "_update_bar")


func start_turn() -> void:
	if _is_dead():
		_idle()
		return
	_look_for_player()
	if _saw_player:
		_chase_player()
	else:
		_wander()


func _look_for_player() -> void:
	#var space_state = get_world_2d().direct_space_state
	var player_pos := _actor_list.player.pos as Vector2
	#var player_center := Vector2(player_pos.x, player_pos.y) * 32 + Vector2(16, 16)
	#var test_point := Vector2(pos.x, pos.y) * 32 + Vector2(16, 16)
	#var occlusion = space_state.intersect_ray(player_center, test_point)
	#if !occlusion or (occlusion.position - test_point).length() < 1:
	if _map.line_is_free(pos, player_pos):
		_saw_player = true
		_last_seen_player_pos = player_pos


func _chase_player() -> void:
	var path := _map.find_path(pos, _last_seen_player_pos)
	if path.size() > 2:
		if _weapon is RangedWeaponItem and _last_seen_player_pos == _actor_list.player.pos and _map.line_is_free(pos, _last_seen_player_pos):
			_shoot_player()
		elif _actor_list.get_alive_actor_by_pos(path[1]) == null:
			var move_dir := (path[1] - pos) as Vector2
			emit_signal("action_move", self, MOVEMENT_COST, pos + move_dir)
		else:
			emit_signal("action_idle", self, IDLE_COST)
	elif path.size() == 2:
		if _actor_list.player.pos == path[1]:
			emit_signal("action_attack", self, _weapon.attack_cost, _actor_list.player, _get_damage())
		else:
			var move_dir := (path[1] - pos) as Vector2
			_saw_player = false
			emit_signal("action_move", self, MOVEMENT_COST, pos + move_dir)
	else:
		emit_signal("action_idle", self, IDLE_COST)


func _shoot_player() -> void:
	var ranged = _weapon as RangedWeaponItem
	emit_signal("action_shoot", self, ranged.attack_cost, _actor_list.player, _get_damage(), ranged.projectile_scene)


func _wander() -> void:
	var options := []
	for dir in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]:
		if _map.is_free(pos + dir):
			options.append(dir)
	var move_dir := options[randi() % options.size()] as Vector2
	emit_signal("action_move", self, MOVEMENT_COST, pos + move_dir)


func _idle() -> void:
	emit_signal("action_idle", self, IDLE_COST)
