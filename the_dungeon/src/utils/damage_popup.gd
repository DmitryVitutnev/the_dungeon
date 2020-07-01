extends Position2D
class_name DamagePopup


var amount : int


onready var _text := $Label as Label
onready var _tween := $Tween as Tween


func _ready():
	_text.text = str(amount)
	
	_tween.interpolate_property(self, "scale", scale, Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	_tween.start()


func _on_tween_all_completed():
	print(position)
	self.queue_free()
