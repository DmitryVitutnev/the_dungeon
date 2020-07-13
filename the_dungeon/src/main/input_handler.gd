extends Node


"""
Useless class. Don't know how to separate input yet.
"""


signal click_pressed(position)
signal click_released(position)


func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			emit_signal("click_pressed", event.position)
		else:
			emit_signal("click_released", event.position)
	
