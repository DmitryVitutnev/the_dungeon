extends Actor


func start_turn():
	var player_pos := _actor_list.get_player().pos as Vector2
	var path := _map.find_path(pos, player_pos)
	if path.size() > 2:
		var move_dir := (path[1] - pos) as Vector2
		emit_signal("move", move_dir, 2)
	else:
		# TODO write code for attack
		emit_signal("move", Vector2.ZERO, 2)
