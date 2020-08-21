extends Panel
class_name ItemInfo


var _item : EquipableItem


onready var name_text := $Name
onready var stats_text := $Stats


func update_item(new_item : Item) -> void:
	_item = new_item
	_update_text()


func _update_text() -> void:
	name_text.bbcode_text = _item.full_name + "\n"
	
	match _item.rarity:
		ItemDB.Rarity.WHITE:
			name_text.bbcode_text = "[color=white]" + name_text.bbcode_text + "[/color]"
		ItemDB.Rarity.BLUE:
			name_text.bbcode_text = "[color=blue]" + name_text.bbcode_text + "[/color]"
		ItemDB.Rarity.YELLOW:
			name_text.bbcode_text = "[color=yellow]" + name_text.bbcode_text + "[/color]"
		ItemDB.Rarity.RED:
			name_text.bbcode_text = "[color=red]" + name_text.bbcode_text + "[/color]"
		ItemDB.Rarity.GREEN:
			name_text.bbcode_text = "[color=green]" + name_text.bbcode_text + "[/color]"
	
	var new_text := ""
	new_text += "slot : " + str(Enum.EquipmentSlot.keys()[_item.slot]) + "\n"
	if _item is WeaponItem:
		var weapon = _item as WeaponItem
		new_text += "damage : " + str(weapon.min_damage) + "-" + str(weapon.max_damage) + "\n"
		new_text += "attack cost : " + str(weapon.attack_cost) + "\n"
	if _item is ArmorItem:
		new_text += "armor : " + str(_item.armor) + "\n"
		
	stats_text.text = new_text
