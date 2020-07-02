extends Control
class_name LootInfo


var _loot_map : LootMap
var _target_pos : Vector2


onready var _text_box := $Text


func initialize(loot_map : LootMap) -> void:
	_loot_map = loot_map
	visible = false


func set_target_pos(pos : Vector2) -> void:
	_target_pos = pos


func show_items() -> void:
	var items := _loot_map.get_items_by_pos(_target_pos)
	var text := ""
	for i in items:
		var item := i as Item
		match item.rarity:
			ItemDB.Rarity.WHITE:
				text += "[color=white]" + item.full_name + "\n" + "[/color]"
			ItemDB.Rarity.BLUE:
				text += "[color=blue]" + item.full_name + "\n" + "[/color]"
			ItemDB.Rarity.YELLOW:
				text += "[color=yellow]" + item.full_name + "\n" + "[/color]"
			ItemDB.Rarity.ORANGE:
				text += "[color=red]" + item.full_name + "\n" + "[/color]"
			ItemDB.Rarity.GREEN:
				text += "[color=green]" + item.full_name + "\n" + "[/color]"
	_text_box.bbcode_text = text
	if text == "":
		visible = false
	else:
		visible = true
