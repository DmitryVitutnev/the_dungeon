extends Node2D
class_name Item


signal taken(item)


var full_name : String setget ,_get_full_name
var value : int setget ,_get_value
var icon : Texture setget ,_get_icon


func initialize(resource : Resource) -> void:
	var res := resource as ItemRes
	full_name = res.name
	value = res.value
	icon = res.icon


func _get_full_name() -> String:
	return full_name


func _get_value() -> int:
	return value


func _get_icon() -> Texture:
	return icon
