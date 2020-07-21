extends NotStackableItem
class_name EquipableItem

var slot : String setget ,_get_slot
var texture : Texture setget ,_get_texture
var rarity : int
var ancient : bool
var modifiers := []

var damage : String setget ,_get_damage
var armor : int setget ,_get_armor
var speed : int setget ,_get_speed


func initialize(resource : Resource) -> void:
	var res := resource as EquipableItemRes
	.initialize(res)
	slot = res.slot
	texture = res.texture


func _get_slot() -> String:
	return slot


func _get_texture() -> Texture:
	return texture


func _get_damage() -> String:
	var result := ""
	for m in modifiers:
		var mod := m as ItemModifierRes
		result += "+" + mod.damage
	if ancient:
		result = result + result
	return result


func _get_armor() -> int:
	var result := 0
	for m in modifiers:
		var mod := m as ItemModifierRes
		result += mod.armor
	if ancient:
		result = result + result
	return result


func _get_speed() -> int:
	var result := 0
	for m in modifiers:
		var mod := m as ItemModifierRes
		result += mod.speed
	if ancient:
		result = result + result
	return result


func _get_full_name() -> String:
	var result := full_name
	if modifiers.size() >= 1:
		result = modifiers[0].prefix_name + " " + result
	
	if modifiers.size() >= 2:
		result = result + " " + modifiers[1].postfix_name
	
	if ancient:
		result = "ancient " + result
	
	return result
