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
	new_text += "slot : " + str(_item.slot) + "\n"
	if _item.damage != "":
		new_text += "damage : " + Roll.from_d_to_interval(_item.damage) + "\n"
	if _item is WeaponItem:
		var weapon = _item as WeaponItem
		new_text += "attack cost : " + str(weapon.attack_cost) + "\n"
	if _item.armor != 0:
		new_text += "armor : " + str(_item.armor) + "\n"
	if _item.speed != 0:
		new_text += "speed : " + str(_item.speed) + "\n"
		
	stats_text.text = new_text
