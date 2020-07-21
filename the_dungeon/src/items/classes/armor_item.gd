extends EquipableItem
class_name ArmorItem


var base_armor : int setget ,_get_base_armor


func initialize(resource : Resource) -> void:
	var res := resource as ArmorItemRes
	.initialize(res)
	base_armor = res.armor


func _get_base_armor() -> int:
	return base_armor


func _get_armor() -> int:
	return base_armor + ._get_armor()
