extends Control
class_name LootInfoLine


signal pick_up(item)


var _item : Item


onready var _button := $Button as Button
onready var _text := $Button/RichTextLabel as RichTextLabel


func initialize(item : Item) -> void:
	_item = item
	var text := ""
	match _item.rarity:
		ItemDB.Rarity.WHITE:
			text += "[color=white]" + _item.full_name + "\n" + "[/color]"
		ItemDB.Rarity.BLUE:
			text += "[color=blue]" + _item.full_name + "\n" + "[/color]"
		ItemDB.Rarity.YELLOW:
			text += "[color=yellow]" + _item.full_name + "\n" + "[/color]"
		ItemDB.Rarity.RED:
			text += "[color=red]" + _item.full_name + "\n" + "[/color]"
		ItemDB.Rarity.GREEN:
			text += "[color=green]" + _item.full_name + "\n" + "[/color]"
	_text.bbcode_text = text
	_button.connect("pressed", self, "_pressed")


func _pressed() -> void:
	emit_signal("pick_up", _item)
	pass
