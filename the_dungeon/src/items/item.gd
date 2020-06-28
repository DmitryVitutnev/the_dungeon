extends Node2D
class_name Item


var full_name : String setget ,_get_full_name
var value : int setget ,_get_value
var damage : String setget ,_get_damage
var armor : int setget ,_get_armor
var slot : String
var icon : Texture
var texture : Texture


var _stats := Resource
var _modifiers := []


func _ready():
	full_name = _stats.name
	value = _stats.value
	damage = _stats.damage
	armor = _stats.armor
	slot = _stats.slot
	icon = _stats.icon
	texture = _stats.texture


func _get_full_name() -> String:
	var result := full_name
	if _modifiers.size() >= 1:
		result = _modifiers[0].prefix_name + " " + result
	
	if _modifiers.size() >= 2:
		result = result + " " + _modifiers[1].postfix_name
	return result


func _get_value() -> int:
	var result := value
	for mod in _modifiers:
		result += mod.value
	return result


func _get_damage() -> String:
	var result := damage
	for mod in _modifiers:
		if mod.damage != "":
			result += "+" + mod.damage
	return result


func _get_armor() -> int:
	var result := armor
	for mod in _modifiers:
		result += mod.armor
	return result
