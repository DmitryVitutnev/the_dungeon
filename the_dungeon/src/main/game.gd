extends Node2D


var _current_level := 0
var _player_scene := load("res://assets/player.tscn") as PackedScene
var _enemy_scene := load("res://assets/enemy.tscn") as PackedScene
var _player : PlayerActor
var _game_just_started := true
var _boss_alive := false


onready var _map := $Map as Map
onready var _visibility_map := $VisibilityMap as VisibilityMap
onready var _loot_map := $LootMap as LootMap
onready var _actor_controller := $ActorController as ActorController
onready var _ui := $Canvas/UI as UI
onready var _inventory := $Canvas/Inventory as Inventory
onready var _greetings := $Canvas/UI/GreetingsScreen
onready var _for_player := $ForPlayer


func _ready() -> void:
	_visibility_map.initialize(_map)
	_actor_controller.initialize(_map, _visibility_map)
	_start_game()


func _start_game() -> void:
	randomize()
	_player = _create_player()
	
	_ui.initialize(_player, _loot_map, _inventory)
	_inventory.initialize(_player)
	_greetings.visible = true
	_game_just_started = true
	
	_current_level = -1
	_next_level()


func _next_level() -> void:
	_current_level += 1
	_ui.set_level(_current_level + 1)
	
	if _current_level >= Consts.LEVEL_SIZES.size():
		_win()
		return
	
	_build_level(Consts.LEVEL_SIZES[_current_level], Consts.LEVEL_ROOM_COUNTS[_current_level])
	_place_player(_player)
	_spawn_enemies(Consts.LEVEL_ENEMY_COUNTS[_current_level])
	_spawn_items()
	if _current_level == Consts.LEVEL_SIZES.size() - 1:
		_boss_alive = true
		_spawn_boss()
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_callback(_visibility_map, 0.01, "update_fog", _player.pos)
	tween.interpolate_callback(tween, 0, "queue_free")
	tween.start()
	_actor_controller.start_game()


func _build_level(size : Vector2, room_number : int) -> void:
	_map.build_level(size, room_number)
	_visibility_map.reset(size)
	_loot_map.reset(size)
	_actor_controller.clear()


func _create_player() -> Actor:
	var player =  _player_scene.instance() as Actor
	_for_player.add_child(player)
	player.initialize(_map, _actor_controller._actor_list)
	player.connect("death", self, "_defeat")
	player.connect("item_picked_up", _loot_map, "remove_item")
	player.connect("item_dropped", _loot_map, "add_item")
	return player


func _place_player(player : Actor) -> void:
	_actor_controller.add_player(_player)


func _spawn_enemies(enemy_number : int) -> void:
	for i in range(enemy_number):
		var enemy := _enemy_scene.instance() as Actor
		_actor_controller.add_enemy(enemy)
		enemy.connect("item_picked_up", _loot_map, "remove_item")
		enemy.connect("item_dropped", _loot_map, "add_item")
		var weapon := ItemDB.generate_weapon(_current_level)
		enemy.pickup_item(weapon)
		enemy.equip_item(weapon)
		for j in range(_current_level):
			var item := ItemDB.generate_armor(_current_level)
			if !enemy._equipped_items.has(item.slot):
				enemy.pickup_item(item)
				enemy.equip_item(item)


func _spawn_boss() -> void:
	var boss := _enemy_scene.instance() as Actor
	_actor_controller.add_enemy(boss)
	boss.connect("death", self, "_boss_killed")
	boss.connect("item_picked_up", _loot_map, "remove_item")
	boss.connect("item_dropped", _loot_map, "add_item")
	var equipment := ItemDB.generate_boss_equipment()
	for i in equipment:
		var item := i as Item
		boss.pickup_item(item)
		boss.equip_item(item)


func _spawn_items() -> void:
	if _current_level == 0:
		var starting_weapon = ItemDB.generate_starting_weapon()
		var pos : Vector2
		var dirs = [Vector2(0, 1), Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
		dirs.shuffle()
		for dir in dirs:
			if _map.is_free(_player.pos + dir):
				pos = _player.pos + dir
				break
		_loot_map.add_item(starting_weapon, pos)


func _win() -> void:
	_ui._win_screen.visible = true


func _defeat(player : Actor) -> void:
	_ui._defeat_screen.visible = true
	_ui._defeat_screen.appear()


func _boss_killed(boss : Actor) -> void:
	_boss_alive = false


func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if _player.dead:
		return
	if _game_just_started:
		if event.is_action_pressed("interact"):
			_game_just_started = false
			_greetings.visible = false
		return
	if event.is_action_pressed("interact"):
		var items := _loot_map.get_items_by_pos(_player.pos)
		for i in items:
			var item := i as Item
			_inventory.pickup_item(item)
		if _player.pos == _map.exit_pos and !_boss_alive:
			_next_level()
		return
	if event.is_action_pressed("inv_open"):
		_inventory.visible = !_inventory.visible
		return
	if _inventory.visible:
		_inventory.handle_input(event)
	else:
		var click_pos := _map.coord_to_pos(get_global_mouse_position())
		if !((event is InputEventMouseButton or event is InputEventScreenTouch) and !_visibility_map.pos_is_visible(click_pos)):
			_player.handle_input(event)
