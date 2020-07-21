extends Item
class_name NotStackableItem


func initialize(resource : Resource) -> void:
	var res := resource as NotStackableItemRes
	.initialize(res)
