extends TextureRect
class_name ItemInInventory


var ICON_DUMMY = preload("res://assets/items/utils/icon_dummy.png")


var item_info : Item setget _set_item_info


func _set_item_info(value : Item) -> void:
	item_info = value
	if item_info.icon != null:
		texture = item_info.icon
	else:
		texture = ICON_DUMMY
	
	set_material(ItemDB.outline_materials[item_info.rarity])
	
