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
		_is_my_turn = false
		if _map.is_free(target_pos):
			var actor = _actor_list.get_alive_actor_by_pos(target_pos)
			if actor == null:
				emit_signal("move", target_pos, stats.recovery_delay)
			else:
				emit_signal("attack", actor, stats.damage, stats.recovery_delay)
		else:
			emit_signal("idle", stats.recovery_delay)
	


func start_turn() -> void:
	_is_my_turn = true


func pickup_item(item : Item) -> void:
	_items.append(item)


func equip_item(item : Item) -> void:
	_equipped_items[item.slot] = item
	appearance.set_texture(item.texture, item.slot)


func unequip_item(item : Item) -> void:
	_equipped_items[item.slot] = null
	appearance.free_slot(item.slot)
