extends Node2D
class_name Item


# TODO Temporal solution. I should think about this
signal taken(item)


var full_name : String setget ,_get_full_name
var value : int setget ,_get_value
var damage : String setget ,_get_damage
var armor : int setget ,_get_armor
var max_health : int setget ,_get_max_health
var speed : int setget ,_get_speed
var slot : String
var icon : Texture
var texture : Texture
var ancient := false
var rarity : int


var _stats := Resource
var _modifiers := []


func _ready():
	full_name = _stats.name
	value = _stats.value
	damage = _stats.damage
	armor = _stats.armor
	max_health = _stats.max_health
	speed = _stats.speed
	slot = _stats.slot
	icon = _stats.icon
	texture = _stats.texture


func _get_full_name() -> String:
	var result := full_name
	if _modifiers.size() >= 1:
		result = _modifiers[0].prefix_name + " " + result
	
	if _modifiers.size() >= 2:
		result = result + " " + _modifiers[1].postfix_name
	
	if ancient:
		result = "ancient " + result
	
	return result


func _get_value() -> int:
	var result := value
	for mod in _modifiers:
		result += mod.value
	return result


func _get_damage() -> String:
	var result := ""
	for mod in _modifiers:
		if mod.damage != "":
			result += "+" + mod.damage
	if ancient:
		result = result + result
	result = damage + result
	return result


func _get_armor() -> int:
	var result := armor
	for mod in _modifiers:
		result += mod.armor
	if ancient:
		result *= 2
	return result


func _get_max_health() -> int:
	var result := max_health
	for mod in _modifiers:
		result += mod.max_health
	if ancient:
		result *= 2
	return result


func _get_speed() -> int:
	var result := speed
	for mod in _modifiers:
		result += mod.speed
	if ancient:
		result *= 2
	return result
