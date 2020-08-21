extends Control
class_name LootInfo


var line_scene = load("res://src/items/loot_info_line.tscn")


var _loot_map : LootMap
var _inventory : Inventory
var _target_pos : Vector2
var _lines := []


onready var _scroll_container := $ScrollContainer/VBoxContainer


func initialize(loot_map : LootMap, inventory : Inventory) -> void:
	_loot_map = loot_map
	_inventory = inventory
	visible = false


func set_target_pos(pos : Vector2) -> void:
	_target_pos = pos


func show_items() -> void:
	for l in _lines:
		l.queue_free()
	_lines.clear()
	var items := _loot_map.get_items_by_pos(_target_pos)
	for i in items:
		var item := i as Item
		var line := line_scene.instance() as LootInfoLine
		_scroll_container.add_child(line)
		line.initialize(item)
		line.connect("pick_up", self, "_pick_up_item")
		_lines.append(line)
	if items.empty():
		visible = false
	else:
		visible = true


func _pick_up_item(item : Item) -> void:
	_inventory.pickup_item(item)
