extends Node2D
class_name ActorController



var _map : Map
var _visibility_map : VisibilityMap
var _current_delay := 0.0


onready var _actor_list := $ActorList as ActorList
onready var _turn_queue := $TurnQueue as TurnQueue
onready var _actor_mover := $ActorMover as ActorMover



func initialize(map : Map, visibility_map : VisibilityMap):
	_map = map
	_visibility_map = visibility_map
	_actor_mover.connect("finished", self, "_next_turn")


func start_game() -> void:
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()


func add_player(player : PlayerActor) -> void:
	add_actor(player)
	_actor_list.set_player(player)
	


func add_actor(actor : Actor) -> void:
	var pos : Vector2
	while true:
		var pos_x := randi() % int(_map.size.x)
		var pos_y := randi() % int(_map.size.y)
		pos = Vector2(pos_x, pos_y)
		if _map.is_free(pos) and !_actor_list.get_actor_by_pos(pos):
			break
	
	actor.initialize(pos, _map, _actor_list)
	_actor_list.add(actor)
	_turn_queue.push_actor_and_time(actor, 0)
	actor.connect("move", self, "_actor_move")


func _actor_move(dir: Vector2, delay : float) -> void:
	_current_delay = delay
	var actor := _turn_queue.get_current_actor() as Actor
	if dir.length() > 0.001:
		_actor_mover.move_actor(actor, actor.pos + dir)
	else:
		_next_turn()

func _next_turn():
	_turn_queue.next_turn(_current_delay)
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()
	_visibility_map.call_deferred("update_fog", _actor_list.get_player().pos)
	#_visibility_map.update_fog(_actor_list.get_player().pos)
