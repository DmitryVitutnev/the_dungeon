extends Panel
class_name EquipmentSlots


var _items = {}


onready var _slots := $Slots.get_children()
onready var _item_info := get_parent().get_parent().get_node("ItemInfo2") as ItemInfo


func _ready() -> void:
	_item_info.visible = false
	for slot in _slots:
		_items[slot.name] = null


func _process(delta) -> void:
	var cursor_pos := get_global_mouse_position()
	var item = _get_item_under_pos(cursor_pos) as ItemInInventory
	if item != null:
		_item_info.update_item(item.item_info)
		_item_info.set_global_position(cursor_pos)
		_item_info.visible = true
	else:
		_item_info.visible = false


func insert_item(item : ItemInInventory) -> bool:
	if !(item.item_info is EquipableItem):
		return false
	var item_pos = item.rect_global_position + item.rect_size / 2
	var slot = _get_slot_under_pos(item_pos)
	if slot == null:
		return false
	
	var item_slot = item.item_info.slot
	if item_slot != slot.name:
		return false
	if _items[item_slot] != null:
		return false
	_items[item_slot] = item
	item.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - item.rect_size / 2
	
	return true


func grab_item(pos) -> ItemInInventory:
	var item = _get_item_under_pos(pos)
	if item == null:
		return null
	
	var item_slot = item.item_info.slot
	_items[item_slot] = null
	return item


func _get_slot_under_pos(pos : Vector2):
	return _get_thing_under_pos(_slots, pos)


func _get_item_under_pos(pos : Vector2) -> ItemInInventory:
	return _get_thing_under_pos(_items.values(), pos)


func _get_thing_under_pos(arr : Array, pos : Vector2):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
