extends EquipableItem
class_name WeaponItem


var min_damage : int setget ,_get_min_damage
var max_damage : int setget ,_get_max_damage
var attack_cost : int setget ,_get_attack_cost


func initialize(resource : Resource) -> void:
	var res := resource as WeaponItemRes
	.initialize(res)
	min_damage = res.min_damage
	max_damage = res.max_damage
	attack_cost = res.attack_cost


func _get_min_damage() -> int:
	return min_damage + sum_modifiers_by_type(Enum.EquipmentModifierType.DAMAGE)


func _get_max_damage() -> int:
	return max_damage + sum_modifiers_by_type(Enum.EquipmentModifierType.DAMAGE)


func _get_attack_cost() -> int:
	return attack_cost + sum_modifiers_by_type(Enum.EquipmentModifierType.ATTACK_COST)
