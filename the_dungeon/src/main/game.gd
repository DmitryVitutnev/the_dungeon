extends Node2D


const LEVEL_SIZES := [
	Vector2(30, 30),
	Vector2(35, 35),
	Vector2(40, 40),
	Vector2(45, 45),
	Vector2(50, 50)
]
const LEVEL_ROOM_COUNTS := [5, 7, 9, 12, 15]
const LEVEL_ENEMY_COUNTS := [50, 9, 12, 15, 20]


var _current_level := 0
var _player_scene := load("res://assets/player.tscn") as PackedScene
var _enemy_scene := load("res://assets/enemy.tscn") as PackedScene
var _player : PlayerActor


onready var _map := $Map as Map
onready var _visibility_map := $VisibilityMap as VisibilityMap
onready var _actor_controller := $ActorController as ActorController
onready var _ui := $CanvasLayer/UI as UI


func _ready() -> void:
	_restart_game()


func _restart_game() -> void:
	randomize()
	_player = _player_scene.instance()
	_player.connect("player_health_changed", self, "_player_health_changed")
	_current_level = -1
	_next_level()


func _next_level() -> void:
	_current_level += 1
	_map.build_level(LEVEL_SIZES[_current_level], LEVEL_ROOM_COUNTS[_current_level])
	_visibility_map.initialize(LEVEL_SIZES[_current_level])
	
	_actor_controller.initialize(_map, _visibility_map)
	
	_actor_controller.add_player(_player)
	for i in range(LEVEL_ENEMY_COUNTS[_current_level]):
		_actor_controller.add_enemy(_enemy_scene.instance())
	_actor_controller.start_game()
	
	_ui.set_health(_player._health)
	_ui.set_level(_current_level + 1)
	

	
	


func _player_health_changed(new_health : int) -> void:
	_ui.set_health(new_health)


func _input(event):
	if event.is_action("ui_accept"):
		_restart_game()
