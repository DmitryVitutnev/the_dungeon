extends Node2D
class_name ActorAppearance


var _slots := {}


onready var slots := $Slots


func _ready() -> void:
	var sprites = slots.get_children()
	for s in sprites:
		_slots[s.name] = s


func set_texture(texture : Texture, slot : String) -> void:
	if _slots.has(slot):
		var s = _slots[slot] as Sprite
		s.texture = texture


func free_slot(slot : String) -> void:
	if _slots.has(slot):
		var s = _slots[slot] as Sprite
		s.texture = null


func set_alive() -> void:
	slots.rotation = 0.0
	slots.self_modulate = Color(1, 1, 1, 1)


func set_dead() -> void:
	slots.rotation = randf() * 2 * PI
	slots.modulate = Color(1, 1, 1, 0.5)
