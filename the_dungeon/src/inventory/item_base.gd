extends TextureRect
class_name ItemInInventory


var item_info : Item setget _set_item_info


func _set_item_info(value : Item) -> void:
	item_info = value
	texture = item_info.icon
	set_material(ItemDB.outline_materials[item_info.rarity])
	
