extends Control
class_name Inventory


const ITEM_BASE := preload("res://src/inventory/item_base.tscn")


onready var inv_base := $InventoryBase
onready var grid_bkpk :=  $GridBackPack as GridBackPack
onready var eq_slots := $EquipmentSlots as EquipmentSlots


var _item_held : Control
var _item_offset : Vector2
var _last_container : Control
var _last_pos : Vector2


func _ready():
	pickup_item("sword")
	pickup_item("sword")
	pickup_item("sword")
	pickup_item("axe")
	pickup_item("hello")


func _process(delta) -> void:
	var cursor_pos := get_global_mouse_position()
	if Input.is_action_just_pressed("inv_grab"):
		_grab(cursor_pos)
	if Input.is_action_just_released("inv_grab"):
		_release(cursor_pos)
	if _item_held != null:
		_item_held.rect_global_position = cursor_pos + _item_offset


func pickup_item(item_id):
	var item = ITEM_BASE.instance()
	item.set_meta("id", item_id)
	item.texture = load(ItemDB.get_item(item_id)["icon"])
	add_child(item)
	if !grid_bkpk.insert_item_at_first_available_slot(item):
		item.queue_free()
		return false
	return true


func _grab(cursor_pos) -> void:
	var c = _get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		_item_held = c.grab_item(cursor_pos)
		if _item_held != null:
			_last_container = c
			_last_pos = _item_held.rect_global_position
			_item_offset = _item_held.rect_global_position - cursor_pos
			move_child(_item_held, get_child_count())


func _release(cursor_pos) -> void:
	if _item_held == null:
		return
	var c = _get_container_under_cursor(cursor_pos)
	if c == null:
		_drop_item()
	elif c.has_method("insert_item"):
		if c.insert_item(_item_held):
			_item_held = null
		else:
			_return_item()
	else:
		_return_item()


func _get_container_under_cursor(cursor_pos):
	var containers = [grid_bkpk, eq_slots, inv_base]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			print(c.name)
			return c
	return null


func _drop_item() -> void:
	_item_held.queue_free()
	_item_held = null


func _return_item() -> void:
	_item_held.rect_global_position = _last_pos
	_last_container.insert_item(_item_held)
	_item_held = null

