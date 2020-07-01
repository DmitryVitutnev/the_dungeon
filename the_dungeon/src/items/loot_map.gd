extends Node2D
class_name LootMap


var _items = {}
var _size : Vector2


onready var _tilemap := $TileMap as TileMap


func reset(size : Vector2) -> void:
	_size = size
	_items.clear()
	for x in range(size.x):
		for y in range(size.y):
			_tilemap.set_cell(x, y, -1)


func add_item(item : Item, pos : Vector2) -> void:
	_items[item] = pos
	_tilemap.set_cell(pos.x, pos.y, 0)


func remove_item(item : Item) -> void:
	if !_items.has(item):
		return
	var pos := _items[item] as Vector2
	_items.erase(item)
	if !_items.values().has(pos):
		_tilemap.set_cell(pos.x, pos.y, -1)


func get_items_by_pos(pos : Vector2) -> Array:
	var result := []
	for i in _items.keys():
		var item := i as Item
		if _items[item] == pos:
			result.append(item)
	return result
