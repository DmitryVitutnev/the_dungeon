extends NotStackableItem
class_name EquipableItem

var slot : int setget ,_get_slot
var texture : Texture setget ,_get_texture
var rarity : int
var ancient : bool
var modifiers := []


func initialize(resource : Resource) -> void:
	var res := resource as EquipableItemRes
	.initialize(res)
	slot = res.slot
	texture = res.texture


func sum_modifiers_by_type(type : int) -> int:
	var result = 0
	for m in modifiers:
		var mod = m as ItemModifierRes
		if mod.type == type:
			result += mod.value
	return result


func _get_slot() -> int:
	return slot


func _get_texture() -> Texture:
	return texture


func _get_full_name() -> String:
	var result := full_name
	if modifiers.size() >= 1:
		result = modifiers[0].name + " " + result
	
	if ancient:
		result = "ancient " + result
	
	return result

