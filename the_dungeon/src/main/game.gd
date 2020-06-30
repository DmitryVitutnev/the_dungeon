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
onready var _actor_controller := $ActorController as ActorController
onready var _ui := $UI as UI
onready var _win_screen = $UI/WinScreen
onready var _defeat_screen = $UI/DefeatScreen
onready var _inventory = $UI/Inventory


func _ready() -> void:
	_visibility_map.initialize(_map)
	_actor_controller.initialize(_map, _visibility_map)
	_start_game()


func _start_game() -> void:
	randomize()
	_player = _player_scene.instance() as Actor
	add_child(_player)
	_player.initialize(_map, _actor_controller._actor_list)
	_player.connect("stats_changed", self, "_player_health_changed")
	_player.connect("death", self, "_defeat")
	
	_inventory.connect("item_equipped", _player, "equip_item")
	_inventory.connect("item_unequipped", _player, "unequip_item")
	
	_current_level = -1
	_next_level()
	_win_screen.visible = false
	_defeat_screen.visible = false
	_inventory.visible = false


func _next_level() -> void:
	_current_level += 1
	
	if _current_level >= LEVEL_SIZES.size():
		_win()
		return
	
	# Temporal solution. So player will have some items each level
	for i in range(2):
		var item = ItemDB.generate_item()
		_inventory.pickup_item(item)
	
	_map.build_level(LEVEL_SIZES[_current_level], LEVEL_ROOM_COUNTS[_current_level])
	_visibility_map.reset(LEVEL_SIZES[_current_level])
	_actor_controller.clear()
	_actor_controller.add_player(_player)
	
	for i in range(LEVEL_ENEMY_COUNTS[_current_level]):
		var enemy := _enemy_scene.instance() as Actor
		_actor_controller.add_enemy(enemy)
		for j in range(_current_level + 1):
			enemy.equip_item(ItemDB.generate_item())
	_actor_controller.start_game()
	
	_ui.set_health(_player.health)
	_ui.set_level(_current_level + 1)
	

func _player_health_changed() -> void:
	_ui.set_health(_player.health)


func _win() -> void:
	_win_screen.visible = true


func _defeat(player : Actor) -> void:
	_start_game()
	_defeat_screen.visible = true


func _input(event):
	if event.is_action_pressed("interact"):
		if _player.pos == _map.exit_pos:
			_next_level()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("inv_open"):
		_inventory.visible = !_inventory.visible
