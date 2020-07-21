extends WeaponItem
class_name RangedWeaponItem


var projectile_scene : PackedScene setget ,_get_projectile_scene


func initialize(resource : Resource) -> void:
	var res := resource as RangedWeaponItemRes
	.initialize(res)
	projectile_scene = res.projectile_scene


func _get_projectile_scene() -> PackedScene:
	return projectile_scene
