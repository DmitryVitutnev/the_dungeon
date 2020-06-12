extends Node2D


const LEVEL_SIZES := [
	Vector2(30, 30),
	Vector2(35, 35),
	Vector2(40, 40),
	Vector2(45, 45),
	Vector2(50, 50)
]
const LEVEL_ROOM_COUNTS := [5, 7, 9, 12, 15]


var current_level := 0


onready var map := $Map as Map
onready var visibility_map := $VisibilityMap as VisibilityMap
onready var actor_controller := $ActorController as ActorController
onready var player := $Player as PlayerActor
onready var enemy := $Enemy as Actor


func _ready() -> void:
	_restart_game()
	player.connect("player_health_changed", self, "_player_health_changed")


func _restart_game() -> void:
	randomize()
	current_level = 0
	map.build_level(LEVEL_SIZES[current_level], LEVEL_ROOM_COUNTS[current_level])
	visibility_map.initialize(LEVEL_SIZES[current_level])
	
	# TODO add clear of actors
	actor_controller.initialize(map, visibility_map)
	actor_controller.add_player(player)
	actor_controller.add_actor(enemy)
	actor_controller.start_game()


func _player_health_changed(new_health : int) -> void:
	pass

