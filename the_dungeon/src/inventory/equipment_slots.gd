extends Panel
class_name EquipmentSlots


var _items = {}


onready var _slots = get_children()


func _ready() -> void:
	for slot in _slots:
		_items[slot.name] = null


func insert_item(item) -> bool:
	var item_pos = item.rect_global_position + item.rect_size / 2
	var slot = _get_slot_under_pos(item_pos)
	if slot == null:
		return false
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	if item_slot != slot.name:
		return false
	if _items[item_slot] != null:
		return false
	_items[item_slot] = item
	item.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - item.rect_size / 2
	
	return true


func grab_item(pos):
	var item = _get_item_under_pos(pos)
	if item == null:
		return null
	
	var item_slot = ItemDB.get_item(item.get_meta("id"))["slot"]
	_items[item_slot] = null
	return item


func _get_slot_under_pos(pos : Vector2):
	return _get_thing_under_pos(get_children(), pos)


func _get_item_under_pos(pos : Vector2):
	return _get_thing_under_pos(_items.values(), pos)


func _get_thing_under_pos(arr : Array, pos : Vector2):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
