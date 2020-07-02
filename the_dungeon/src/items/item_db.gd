extends Node

const STATS_PATH := "res://assets/items/stats/"
const MODIFIERS_PATH := "res://assets/items/modifiers/"
const UNIQUE_STATS_PATH := "res://assets/items/unique_stats/"

enum Rarity {
	GRAY, WHITE, BLUE, YELLOW, ORANGE, GREEN
}

#Temporal solution
var starting_weapon_stats := load("res://assets/items/stats/club.tres")


var _stats := []
var _weapon_stats := []
var _armor_stats := []
var _modifiers := []
var _items := []
var _unique_item_stats := []


func _ready() -> void:
	var dir = Directory.new()
	dir.open(STATS_PATH)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !file_name.begins_with("."):
			var stats = load(STATS_PATH + file_name)
			_stats.append(stats)
			if stats.slot == "MAIN_HAND":
				_weapon_stats.append(stats)
			else:
				_armor_stats.append(stats)
		file_name = dir.get_next()
	
	dir.open(MODIFIERS_PATH)
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if !file_name.begins_with("."):
			var mod = load(MODIFIERS_PATH + file_name)
			_modifiers.append(mod)
		file_name = dir.get_next()
	
	dir.open(UNIQUE_STATS_PATH)
	dir.list_dir_begin()
	file_name = dir.get_next()
	while file_name != "":
		if !file_name.begins_with("."):
			var unique_stats = load(UNIQUE_STATS_PATH + file_name)
			_unique_item_stats.append(unique_stats)
		file_name = dir.get_next()


func generate_item() -> Item:
	return _generate_item_from_list(_stats)


func generate_weapon() -> Item:
	return _generate_item_from_list(_weapon_stats)


func generate_armor() -> Item:
	return _generate_item_from_list(_armor_stats)


func generate_starting_weapon() -> Item:
	var item = Item.new()
	item._stats = starting_weapon_stats
	item.rarity = Rarity.WHITE
	add_child(item)
	_items.append(item)
	return item


func generate_boss_equipment() -> Array:
	var result := []
	for stat in _unique_item_stats:
		var item = Item.new()
		item._stats = stat
		item.rarity = Rarity.GREEN
		add_child(item)
		_items.append(item)
		result.append(item)
	return result


func _generate_item_from_list(list : Array) -> Item:
	var item := Item.new()
	item._stats = list[randi() % list.size()]
	item.rarity = Rarity.WHITE
	if Roll.d3(1) == 3:
		item._modifiers.append(_modifiers[randi() % _modifiers.size()])
		item.rarity = Rarity.BLUE
		if Roll.d3(1) == 3:
			item._modifiers.append(_modifiers[randi() % _modifiers.size()])
			item.rarity = Rarity.YELLOW
			if Roll.d3(1) == 3:
				item.ancient = true
				item.rarity = Rarity.ORANGE
	add_child(item)
	_items.append(item)
	return item
