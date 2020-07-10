extends Control
class_name Inventory


signal item_equipped(item)
signal item_unequipped(item)
signal item_picked_up(item)
signal item_dropped(item)


const ITEM_BASE := preload("res://src/inventory/item_base.tscn")


var _item_held : ItemInInventory
var _item_offset : Vector2
var _last_container : Control
var _last_pos : Vector2
var _item_can_be_returned : bool


onready var inv_base := $Main/InventoryBase
onready var grid_bkpk :=  $Main/GridBackPack as GridBackPack
onready var eq_slots := $Main/EquipmentSlots as EquipmentSlots
onready var items := $Items as Control


func _process(delta) -> void:
	if !visible:
		return
	var cursor_pos := get_global_mouse_position()
	if _item_held != null:
		_item_held.rect_global_position = cursor_pos + _item_offset


func _input(event):
	if !visible:
		return
	var cursor_pos := get_global_mouse_position()
	if event.is_action_pressed("inv_grab"):
		if _item_held == null:
			_grab(cursor_pos)
		else:
			_release(cursor_pos)
	if event.is_action_pressed("inv_drop"):
		if _item_held == null:
			_grab(cursor_pos)
			if _item_held != null:
				_drop_item()
		else:
			if _item_can_be_returned:
				_return_item()


func pickup_item(item_info : Item) -> bool:
	var item = ITEM_BASE.instance()
	items.add_child(item)
	item.item_info = item_info
	if !grid_bkpk.insert_item_at_first_available_slot(item):
		item.queue_free()
		return false
	emit_signal("item_picked_up", item_info)
	return true


func _grab(cursor_pos) -> void:
	var c = _get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		_item_held = c.grab_item(cursor_pos)
		if _item_held != null:
			if c == eq_slots:
				emit_signal("item_unequipped", _item_held.item_info)
			_item_can_be_returned = true
			_last_container = c
			_last_pos = _item_held.rect_global_position
			_item_offset = -_item_held.rect_size / 2
			items.move_child(_item_held, items.get_child_count())


func _release(cursor_pos) -> void:
	if _item_held == null:
		return
	var c = _get_container_under_cursor(cursor_pos)
	if c == null:
		_drop_item()
	elif c.has_method("insert_item"):
		if c.insert_item(_item_held):
			if c == eq_slots:
				emit_signal("item_equipped", _item_held.item_info)
			_item_held = null
		else:
			var new_item = c.grab_item(cursor_pos)
			if new_item != null:
				if c.insert_item(_item_held):
					if c == eq_slots:
						emit_signal("item_unequipped", new_item.item_info)
						emit_signal("item_equipped", _item_held.item_info)
					_item_can_be_returned = false
					_item_held = new_item
					_last_pos = _item_held.rect_global_position
					_last_container = c
					_item_offset = -_item_held.rect_size / 2
					items.move_child(_item_held, items.get_child_count())
				else:
					c.insert_item(new_item)


func _get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, inv_base]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			print(c.name)
			return c
	return null


func _drop_item() -> void:
	emit_signal("item_dropped", _item_held.item_info)
	_item_held.queue_free()
	_item_held = null


func _return_item() -> void:
	if _last_container == eq_slots:
		emit_signal("item_equipped", _item_held.item_info)
	_item_held.rect_global_position = _last_pos
	_last_container.insert_item(_item_held)
	_item_held = null

