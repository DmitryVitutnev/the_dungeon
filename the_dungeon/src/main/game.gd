extends Node2D


const LEVEL_SIZES := [
	Vector2(30, 30),
	Vector2(35, 35),
	Vector2(40, 40),
	Vector2(45, 45),
	Vector2(50, 50)
]
const LEVEL_ROOM_COUNTS := [5, 7, 9, 12, 15]
const LEVEL_ENEMY_COUNTS := [7, 12, 16, 21, 28]


var _current_level := 0
var _player_scene := load("res://assets/player.tscn") as PackedScene
var _enemy_scene := load("res://assets/enemy.tscn") as PackedScene
var _player : PlayerActor


onready var _map := $Map as Map
onready var _visibility_map := $VisibilityMap as VisibilityMap
onready var _loot_map := $LootMap as LootMap
onready var _actor_controller := $ActorController as ActorController
onready var _ui := $UI as UI


func _ready() -> void:
	_visibility_map.initialize(_map)
	_actor_controller.initialize(_map, _visibility_map)
	_start_game()


func _start_game() -> void:
	randomize()
	_player = _player_scene.instance() as Actor
	add_child(_player)
	_player.initialize(_map, _actor_controller._actor_list)
	_player.connect("death", self, "_defeat")
	_player.connect("item_picked_up", _loot_map, "remove_item")
	_player.connect("item_dropped", _loot_map, "add_item")
	
	_ui.initialize(_player, _loot_map)
	
	_current_level = -1
	_next_level()


func _next_level() -> void:
	_current_level += 1
	
	if _current_level >= LEVEL_SIZES.size():
		_win()
		return
	
	_map.build_level(LEVEL_SIZES[_current_level], LEVEL_ROOM_COUNTS[_current_level])
	_visibility_map.reset(LEVEL_SIZES[_current_level])
	_loot_map.reset(LEVEL_SIZES[_current_level])
	_actor_controller.clear()
	_actor_controller.add_player(_player)
	
	for i in range(LEVEL_ENEMY_COUNTS[_current_level]):
		var enemy := _enemy_scene.instance() as Actor
		_actor_controller.add_enemy(enemy)
		enemy.connect("item_picked_up", _loot_map, "remove_item")
		enemy.connect("item_dropped", _loot_map, "add_item")
		for j in range(_current_level + 1):
			var item := ItemDB.generate_item()
			enemy.pickup_item(item)
			enemy.equip_item(item)
	_actor_controller.start_game()
	
	
	#Temporal solution
	if _current_level == 0:
		var sword = ItemDB.generate_weapon()
		var pos : Vector2
		var dirs = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
		dirs.shuffle()
		for dir in dirs:
			if _map.is_free(_player.pos + dir):
				pos = _player.pos + dir
				break
		_loot_map.add_item(sword, pos)
	
	_ui._set_health(_player.health)
	_ui.set_level(_current_level + 1)


func _win() -> void:
	_ui._win_screen.visible = true


func _defeat(player : Actor) -> void:
	_ui._defeat_screen.visible = true


func _input(event):
	if event.is_action_pressed("interact"):
		var items := _loot_map.get_items_by_pos(_player.pos)
		for i in items:
			var item := i as Item
			if (_ui._inventory.pickup_item(item)):
				item.emit_signal("taken", item)
		if _player.pos == _map.exit_pos:
			_next_level()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("inv_open"):
		_ui._inventory.visible = !_ui._inventory.visible
