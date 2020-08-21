extends EquipableItem
class_name ArmorItem


var armor : int setget ,_get_armor


func initialize(resource : Resource) -> void:
	var res := resource as ArmorItemRes
	.initialize(res)
	armor = res.armor


func _get_armor() -> int:
	return armor + sum_modifiers_by_type(Enum.EquipmentModifierType.ARMOR)
