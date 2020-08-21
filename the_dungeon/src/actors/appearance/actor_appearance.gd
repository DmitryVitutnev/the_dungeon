extends Node2D
class_name ActorAppearance


var _eq_slots := {}
var _skin_slots := {}


onready var slots := $Slots
onready var impaled := $Impaled


func _ready() -> void:
	var sprites = slots.get_children()
	for s in sprites:
		if s is AppearanceEquipmentSlot:
			var slot = s as AppearanceEquipmentSlot
			_eq_slots[slot.slot] = slot


func set_item_in_slot(item : EquipableItem, slot : int) -> void:
	if _eq_slots.has(slot):
		var s = _eq_slots[slot] as Sprite
		s.texture = item.texture
		s.set_material(ItemDB.outline_materials[item.rarity])


func free_slot(slot : int) -> void:
	if _eq_slots.has(slot):
		var s = _eq_slots[slot] as Sprite
		s.texture = null
		s.set_material(null)


func set_alive() -> void:
	rotation = 0.0
	self_modulate = Color(1, 1, 1, 1)


func set_dead() -> void:
	rotation = randf() * 2 * PI
	modulate = Color(1, 1, 1, 0.5)
