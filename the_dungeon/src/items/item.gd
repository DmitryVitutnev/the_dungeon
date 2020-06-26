extends Node2D
class_name Item


var full_name : String
var value : int
var damage : String
var defense : int
var icon : Texture


var _stats := Resource
var _modifiers := []


func _ready():
	full_name = _stats.name
	value = _stats.value
	damage = _stats.damage
	defense = _stats.defense
	icon = _stats.icon
	
	for mod in _modifiers:
		value += mod.value
		damage += mod.damage
		defense += mod.defense
	
	if _modifiers.size() >= 1:
		full_name = _modifiers[0].prefix_name + full_name
	
	if _modifiers.size() >= 2:
		full_name = full_name + _modifiers[0].postfix_name
