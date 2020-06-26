extends Node

const STATS_PATH := "res://assets/items/item_stats/"
const MODIFIERS_PATH := "res://assets/items/item_modifiers/"
const ICON_PATH := "res://assets/sprites/items/icons/"

const ITEMS := {
	"sword" : {
		"icon": ICON_PATH + "sword.png",
		"slot": "MAIN_HAND"
	},
	"axe" : {
		"icon": ICON_PATH + "axe.png",
		"slot": "OFF_HAND"
	},
	"error" : {
		"icon": ICON_PATH + "error.png",
		"slot": "NONE"
	}
}


var _stats := []
var _modifiers := []


func _ready() -> void:
	var dir = Directory.new()
	dir.open(STATS_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		_stats.append(load(STATS_PATH + file_name))
		file_name = dir.get_next()
	
	dir.open(MODIFIERS_PATH)
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		_modifiers.append(load(MODIFIERS_PATH + file_name))
		file_name = dir.get_next()


func get_item(item_id : String) -> Dictionary:
	if item_id in ITEMS:
		return ITEMS[item_id]
	else:
		return ITEMS["error"]
	


func generate_item() -> Item:
	var item := Item.new()
	item._stats = _stats[randi() % _stats.size()]
	item._modifiers.append(_modifiers[randi() % _modifiers.size()])
	item._modifiers.append(_modifiers[randi() % _modifiers.size()])
	return item
