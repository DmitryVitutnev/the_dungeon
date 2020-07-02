extends ColorRect


onready var _tween := $Tween as Tween


func appear() -> void:
	_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()

