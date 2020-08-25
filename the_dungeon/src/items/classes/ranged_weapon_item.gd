extends WeaponItem
class_name RangedWeaponItem


var BASIC_PROJECTILE := preload("res://assets/items/utils/basic_projectile.tscn") as PackedScene


var projectile_scene : PackedScene setget ,_get_projectile_scene


func initialize(resource : Resource) -> void:
	var res := resource as RangedWeaponItemRes
	.initialize(res)
	if res.projectile_scene != null:
		projectile_scene = res.projectile_scene
	else:
		projectile_scene = BASIC_PROJECTILE


func _get_projectile_scene() -> PackedScene:
	return projectile_scene
