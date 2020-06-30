extends Node2D
class_name HealthBar


var actor : Actor


onready var _bar := $Bar as ColorRect


func initialize(actor : Actor) -> void:
	self.actor = actor
	_update_bar()


func _update_bar() -> void:
	_bar.set_size(Vector2(int(32 * actor.health / actor.max_health), _bar.rect_size.y))
