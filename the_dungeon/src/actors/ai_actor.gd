extends Actor


var _saw_player := false
var _last_seen_player_pos : Vector2


onready var _health_bar := $HealthBar as HealthBar


func initialize(map : Map, actor_list : ActorList) -> void:
	.initialize(map, actor_list)
	_health_bar.initialize(stats)
	stats.connect("health_changed", _health_bar, "_update_bar")


func start_turn() -> void:
	_look_for_player()
	if _saw_player:
		_chase_player()
	else:
		_wander()


func _look_for_player() -> void:
	#var space_state = get_world_2d().direct_space_state
	var player_pos := _actor_list.get_player().pos as Vector2
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
		if _actor_list.get_actor_by_pos(path[1]) == null:
			var move_dir := (path[1] - pos) as Vector2
			emit_signal("move", pos + move_dir, stats.recovery_delay)
		else:
			emit_signal("idle", 2)
	elif path.size() == 2:
		if _actor_list.get_player().pos == path[1]:
			emit_signal("attack", _actor_list.get_player(), stats.damage, stats.recovery_delay)
		else:
			var move_dir := (path[1] - pos) as Vector2
			_saw_player = false
			emit_signal("move", pos + move_dir, stats.recovery_delay)
	else:
		emit_signal("idle", 2)


func _wander() -> void:
	# TODO Think how enemies should wander when player can't see them
	var options := []
	for dir in [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]:
		if _map.is_free(pos + dir):
			options.append(dir)
	var move_dir := options[randi() % options.size()] as Vector2
	emit_signal("move", pos + move_dir, stats.recovery_delay)


func _idle() -> void:
	emit_signal("idle", stats.recovery_delay)
