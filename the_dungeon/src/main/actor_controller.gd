extends Node2D
class_name ActorController



var _map : Map
var _visibility_map : VisibilityMap
var _current_delay := 0.0


onready var _actor_list := $ActorList as ActorList
onready var _turn_queue := $TurnQueue as TurnQueue
onready var _actor_mover := $ActorMover as ActorMover


#func _ready() -> void:
	#_actor_mover.connect("finished", self, "_next_turn")


func initialize(map : Map, visibility_map : VisibilityMap) -> void:
	_map = map
	_visibility_map = visibility_map
	_actor_list.clear()
	_turn_queue.clear()


func start_game() -> void:
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()


func add_player(player : PlayerActor) -> void:
	var pos = _map.generate_player_pos()
	player.initialize(pos, _map, _actor_list)
	_add_actor(player)
	_actor_list.set_player(player)


func add_enemy(enemy : Actor) -> void:
	var pos = _map.generate_enemy_pos()
	while _actor_list.get_actor_by_pos(pos) != null:
		pos = _map.generate_enemy_pos()
	enemy.initialize(pos, _map, _actor_list)
	_add_actor(enemy)


func _add_actor(actor : Actor) -> void:
	_actor_list.add(actor)
	_turn_queue.push_actor_and_time(actor, 0)
	actor.connect("idle", self, "_actor_idle")
	actor.connect("move", self, "_actor_move")
	actor.connect("attack", self, "_actor_attack")
	actor.connect("death", self,"_actor_death")


func _actor_idle(delay : float) -> void:
	_current_delay = delay
	_next_turn(delay)


func _actor_move(dir : Vector2, delay : float) -> void:
	_current_delay = delay
	var actor := _turn_queue.get_current_actor() as Actor
	_actor_mover.move_actor(actor, actor.pos + dir)
	actor.pos += dir
	
	if _actor_list.get_player() == actor:
		_visibility_map.call_deferred("update_fog", _actor_list.get_player().pos)
	
	_next_turn(delay)


func _actor_attack(target : Actor, damage : int, delay : float) -> void:
	_current_delay = delay
	target.take_damage(damage)
	_next_turn(delay)

func _actor_death(actor : Actor) -> void:
	while(_turn_queue.get_current_actor() == actor):
		_turn_queue.next_turn(1000)
	_turn_queue.remove_actor(actor)
	_actor_list.remove(actor)


func _next_turn(delay : float):
	_turn_queue.next_turn(delay)
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()
	
