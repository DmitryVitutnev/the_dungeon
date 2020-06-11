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
	if movement != Vector2.ZERO:
		_is_my_turn = false
		if _map.is_free(pos + movement):
			emit_signal("move", movement, 1)
		else:
			emit_signal("move", Vector2.ZERO, 1)
	


func start_turn():
	_is_my_turn = true
