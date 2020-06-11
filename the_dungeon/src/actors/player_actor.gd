extends Actor
class_name PlayerActor


var _is_my_turn := false


func _input(event):
	if !_is_my_turn:
		return
	var movement := Vector2.ZERO
	if event.is_action("ui_left"):
		movement = Vector2(-1, 0)
	if event.is_action("ui_right"):
		movement = Vector2(1, 0)
	if event.is_action("ui_up"):
		movement = Vector2(0, -1)
	if event.is_action("ui_down"):
		movement = Vector2(0, 1)
	if movement != Vector2.ZERO and _map.is_free(pos + movement):
		_is_my_turn = false
		emit_signal("move", movement, 1)
	


func start_turn():
	_is_my_turn = true
