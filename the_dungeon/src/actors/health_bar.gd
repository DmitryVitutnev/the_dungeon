extends Node2D
class_name HealthBar

onready var _bar := $Bar as ColorRect


func initialize(actor : Actor) -> void:
	_update_bar(actor)


func _update_bar(actor) -> void:
	_bar.set_size(Vector2(int(32 * actor.health / actor.max_health), _bar.rect_size.y))
