extends Node2D
class_name HealthBar


var _max_health : int


onready var _bar := $Bar as ColorRect


func initialize(stats : ActorStats) -> void:
	_max_health = stats.max_health
	_update_bar(stats.health)


func _update_bar(new_health : int) -> void:
	_bar.set_size(Vector2(int(32 * new_health / _max_health), _bar.rect_size.y))
