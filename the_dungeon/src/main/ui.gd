extends CanvasLayer
class_name UI


onready var _health := $TopBar/Health as Label
onready var _level := $TopBar/Level as Label
onready var _loot_info := $LootInfo as LootInfo
onready var _win_screen := $WinScreen
onready var _defeat_screen := $DefeatScreen
onready var _inventory := $Inventory


func initialize(player : Actor, loot_map : LootMap):
	_loot_info.initialize(loot_map)
	_win_screen.visible = false
	_defeat_screen.visible = false
	_inventory.visible = false
	
	_inventory.connect("item_equipped", player, "equip_item")
	_inventory.connect("item_unequipped", player, "unequip_item")
	_inventory.connect("item_picked_up", player, "pickup_item")
	_inventory.connect("item_dropped", player, "drop_item")
	player.connect("stats_changed", self, "_player_stats_changed")
	player.connect("pos_changed", self, "_player_pos_changed")
	player.connect("item_dropped", self, "_player_item_dropped")
	player.connect("item_picked_up", self, "_player_item_picked_up")
	
	_player_stats_changed(player)


func set_level(value : int) -> void:
	_level.text = "Level: " + String(value)


func _player_stats_changed(player : Actor):
	_set_health(player.health)


func _player_pos_changed(player : Actor) -> void:
	_loot_info.set_target_pos(player.pos)
	_loot_info.show_items()


func _player_item_dropped(item : Item, pos : Vector2) -> void:
	_loot_info.show_items()


func _player_item_picked_up(item : Item) -> void:
	_loot_info.show_items()


func _set_health(value : int) -> void:
	_health.text = "Health: " + String(value)
