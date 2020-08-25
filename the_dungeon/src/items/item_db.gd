extends Node

const STATS_PATH := "res://assets/items/stats/"
const UNIQUE_STATS_PATH := "res://assets/items/unique_stats/"

const WEAPON_FOLDER_PATH := "res://assets/items/weapons/"
const ARMOR_FOLDER_PATH := "res://assets/items/armor/"

const WEAPON_MODIFIERS_PATH := "res://assets/items/modifiers/weapon/"
const ARMOR_MODIFIERS_PATH := "res://assets/items/modifiers/armor/"


enum Type {
	MELEE, RANGED
}

enum Rarity {
	GRAY, WHITE, BLUE, YELLOW, RED, GREEN
}

var outline_materials := {
	Rarity.WHITE : null,
	Rarity.BLUE : preload("res://assets/shaders/blue_outline_material.tres"),
	Rarity.YELLOW : preload("res://assets/shaders/yellow_outline_material.tres"),
	Rarity.RED : preload("res://assets/shaders/red_outline_material.tres"),
	Rarity.GREEN : preload("res://assets/shaders/green_outline_material.tres"),
}

#Temporal solution
var starting_weapon_stats := load("res://assets/items/stats/club.tres")
var fist_weapon_stats := load("res://assets/items/utils/fist.tres")


var _stats := []
var _weapon_stats := []
var _armor_stats := []
var _weapon_modifiers := []
var _armor_modifiers := []
var _items := []
var _unique_item_stats := []


func _ready() -> void:
	
	_weapon_stats = _search_path_for_stats(WEAPON_FOLDER_PATH)
	
	_armor_stats = _search_path_for_stats(ARMOR_FOLDER_PATH)
	
	_weapon_modifiers = _search_path_for_stats(WEAPON_MODIFIERS_PATH)
	
	_armor_modifiers = _search_path_for_stats(ARMOR_MODIFIERS_PATH)
	
	_unique_item_stats = _search_path_for_stats(UNIQUE_STATS_PATH)


func generate_item() -> EquipableItem:
	return _generate_item_from_list(_stats)


func generate_weapon(level : int) -> WeaponItem:
	var list := []
	for w in _weapon_stats:
		var weapon := w as WeaponItemRes
		if weapon.cost <= Consts.MAX_LOOT_COST_ON_LEVEL[level]:
			list.append(weapon)
	var item := _generate_item_from_list(list) as WeaponItem
	if randf() < Consts.FIRST_MODIFIER_CHANCE_ON_LEVEL[level]:
		item.modifiers.append(_weapon_modifiers[randi() % _weapon_modifiers.size()])
		item.rarity = Rarity.YELLOW
	return item


func generate_armor(level : int) -> ArmorItem:
	var item = _generate_item_from_list(_armor_stats) as ArmorItem
	if randf() < Consts.FIRST_MODIFIER_CHANCE_ON_LEVEL[level]:
		item.modifiers.append(_armor_modifiers[randi() % _armor_modifiers.size()])
		item.rarity = Rarity.YELLOW
	return item


func generate_starting_weapon() -> MeleeWeaponItem:
	var item = MeleeWeaponItem.new()
	item.initialize(starting_weapon_stats)
	item.rarity = Rarity.WHITE
	add_child(item)
	_items.append(item)
	return item


func generate_fist_weapon() -> MeleeWeaponItem:
	var item = MeleeWeaponItem.new()
	item.initialize(fist_weapon_stats)
	item.rarity = Rarity.WHITE
	add_child(item)
	_items.append(item)
	return item


func generate_boss_equipment() -> Array:
	var result := []
	for stat in _unique_item_stats:
		var item
		if stat is MeleeWeaponItemRes:
			item = MeleeWeaponItem.new()
		else:
			item = ArmorItem.new()
		item._stats = stat
		item.rarity = Rarity.GREEN
		add_child(item)
		_items.append(item)
		result.append(item)
	return result


func _generate_item_from_list(list : Array) -> EquipableItem:
	var stats = list[randi() % list.size()]
	var item : EquipableItem
	if stats is MeleeWeaponItemRes:
		item = MeleeWeaponItem.new()
	elif stats is RangedWeaponItemRes:
		item = RangedWeaponItem.new()
	elif stats is ArmorItemRes:
		item = ArmorItem.new()
	item.initialize(stats)
	item.rarity = Rarity.WHITE
	add_child(item)
	_items.append(item)
	return item


func _search_path_for_stats(path : String) -> Array:
	var result := []
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name := dir.get_next() as String
		while file_name != "":
			if file_name == "." or file_name == "..":
				pass
			elif dir.current_is_dir():
				result = result + _search_path_for_stats(path + file_name + "/")
				#print("Found directory: " + file_name)
			else:
				if file_name.find("tres") != -1:
					result.append(load(path + file_name))
					print("Added stats: " + file_name)
				#print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path " + path)
	return result

