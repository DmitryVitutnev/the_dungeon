extends EquipableItem
class_name WeaponItem


var base_damage : String setget ,_get_base_attack
var attack_cost : int setget ,_get_attack_cost


func initialize(resource : Resource) -> void:
	var res := resource as WeaponItemRes
	.initialize(res)
	base_damage = res.damage
	attack_cost = res.attack_cost


func _get_base_attack() -> String:
	return base_damage


func _get_attack_cost() -> int:
	return attack_cost


func _get_damage() -> String:
	return base_damage + ._get_damage()
