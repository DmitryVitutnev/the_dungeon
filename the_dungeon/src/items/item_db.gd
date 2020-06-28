extends Node

const STATS_PATH := "res://assets/items/stats/"
const MODIFIERS_PATH := "res://assets/items/modifiers/"


var _stats := []
var _modifiers := []
var _items := []


func _ready() -> void:
	var dir = Directory.new()
	dir.open(STATS_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !file_name.begins_with("."):
			_stats.append(load(STATS_PATH + file_name))
		file_name = dir.get_next()
	
	dir.open(MODIFIERS_PATH)
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if !file_name.begins_with("."):
			_modifiers.append(load(MODIFIERS_PATH + file_name))
		file_name = dir.get_next()


func generate_item() -> Item:
	var item := Item.new()
	item._stats = _stats[randi() % _stats.size()]
	item._modifiers.append(_modifiers[randi() % _modifiers.size()])
	item._modifiers.append(_modifiers[randi() % _modifiers.size()])
	add_child(item)
	_items.append(item)
	return item
