extends Panel
class_name ItemInfo


var _item : Item


onready var name_text = $Name
onready var stats_text = $Stats


func update_item(new_item : Item) -> void:
	_item = new_item
	_update_text()


func _update_text() -> void:
	name_text.text = _item.full_name + "\n"
	var new_text := ""
	if _item.damage != "":
		new_text += "damage : " + str(_item.damage) + "\n"
	if _item.armor != 0:
		new_text += "armor : " + str(_item.armor) + "\n"
	stats_text.text = new_text
