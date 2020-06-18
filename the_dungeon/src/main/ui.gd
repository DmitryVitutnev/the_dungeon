extends CanvasLayer
class_name UI


onready var _health := $Health as Label
onready var _level := $Level as Label


func set_health(value : int) -> void:
	_health.text = "Health: " + String(value)


func set_level(value : int) -> void:
	_level.text = "Level: " + String(value)
