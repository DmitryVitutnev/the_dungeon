extends Node2D
class_name Item


signal taken(item)


var full_name : String setget ,_get_full_name
var cost : int setget ,_get_cost
var icon : Texture setget ,_get_icon


func initialize(resource : Resource) -> void:
	var res := resource as ItemRes
	full_name = res.name
	cost = res.cost
	icon = res.icon


func _get_full_name() -> String:
	return full_name


func _get_cost() -> int:
	return cost


func _get_icon() -> Texture:
	return icon
