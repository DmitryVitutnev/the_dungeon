extends Panel
class_name EquipmentSlots


var _items := []
var _owner : Actor


onready var _slots := $Slots.get_children()


func initialize(owner : Actor) -> void:
	_owner = owner


func insert_item(item : ItemInInventory) -> bool:
	
	var item_pos = item.rect_global_position + item.rect_size / 2
	var slot = _get_slot_under_pos(item_pos) as EquipmentSlot
	if slot == null:
		return false
		
	if !(item.item_info is EquipableItem):
		return false
		
	var eq_item = item.item_info as EquipableItem
	
	if !slot.slots.has(eq_item.slot):
		return false
		
	if !_owner.equip_item(item.item_info):
		return false
		
	_items.append(item)
	item.rect_global_position = slot.rect_global_position + slot.rect_size / 2 - item.rect_size / 2
	
	return true


func grab_item(pos) -> ItemInInventory:
	var item = _get_item_under_pos(pos)
	if item == null:
		return null
	
	_owner.unequip_item(item.item_info)
	_items.erase(item)
	return item


func _get_slot_under_pos(pos : Vector2) -> EquipmentSlot:
	return _get_thing_under_pos(_slots, pos) as EquipmentSlot


func _get_item_under_pos(pos : Vector2) -> ItemInInventory:
	return _get_thing_under_pos(_items, pos)


func _get_thing_under_pos(arr : Array, pos : Vector2):
	for thing in arr:
		if thing != null and thing.get_global_rect().has_point(pos):
			return thing
	return null
