extends Node2D
class_name ActorController


var _actors := []
var _current_actor = 0
var _map : Map


onready var _actor_list := $ActorList
onready var _turn_queue := $TurnQueue as TurnQueue
onready var _actor_mover := $ActorMover as ActorMover



func initialize(map : Map):
	_map = map


func start_game() -> void:
	var actor := _actors[_current_actor] as Actor
	actor.connect("move", self, "_actor_move")
	actor.start_turn()


func add_actor(actor : Actor) -> void:
	actor.initialize(Vector2(15, 15), _map)
	_actors.push_back(actor)
	actor.get_parent().remove_child(actor)
	_actor_list.add_child(actor)
	#_turn_queue.push_actor_and_time(actor, 0)


func _actor_move(dir: Vector2) -> void:
	print("_actor_move")
	var actor := _actors[_current_actor] as Actor
	_actor_mover.connect("finished", self, "_next_turn")
	_actor_mover.move_actor(actor, actor.pos + dir)

func _next_turn():
	var actor := _actors[_current_actor] as Actor
	actor.start_turn()
