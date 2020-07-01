extends Node2D
class_name ActorController



var _map : Map
var _visibility_map : VisibilityMap
var _current_delay := 0.0


onready var _actor_list := $ActorList as ActorList
onready var _turn_queue := $TurnQueue as TurnQueue
onready var _actor_mover := $ActorMover as ActorMover
onready var _actor_attacker := $ActorAttacker as ActorAttacker


func _ready():
	_actor_attacker.connect("finished", self, "_next_turn")


func initialize(map : Map, visibility_map : VisibilityMap) -> void:
	_map = map
	_visibility_map = visibility_map


func start_game() -> void:
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()


func add_player(player : PlayerActor) -> void:
	var pos = _map.generate_player_pos()
	player.pos = pos
	_actor_list.player = player
	
	_add_actor(player)


func add_enemy(enemy : Actor) -> void:
	var pos = _map.generate_enemy_pos()
	while _actor_list.get_alive_actor_by_pos(pos) != null:
		pos = _map.generate_enemy_pos()
	_actor_list.add_enemy(enemy)
	enemy.initialize(_map, _actor_list)
	enemy.pos = pos
	
	_add_actor(enemy)


func clear() -> void:
	_turn_queue.clear()
	_actor_list.clear_enemies()
	_actor_mover.clear()
	_actor_attacker.clear()


func _add_actor(actor : Actor) -> void:
	_turn_queue.push_actor_and_time(actor, 0)
	actor.connect("action_idle", self, "_actor_idle")
	actor.connect("action_move", self, "_actor_move")
	actor.connect("action_attack", self, "_actor_attack")
	
	actor.connect("death", self,"_actor_death")


func _remove_actor(actor : Actor) -> void:
	actor.disconnect("action_idle", self, "_actor_idle")
	actor.disconnect("action_move", self, "_actor_move")
	actor.disconnect("action_attack", self, "_actor_attack")
	actor.disconnect("death", self,"_actor_death")
	_turn_queue.remove_actor(actor)
	_actor_list.remove(actor)
	actor.get_parent().remove_child(actor)


func _actor_idle(delay : float) -> void:
	_current_delay = delay
	_next_turn()


func _actor_move(target_pos : Vector2, delay : float) -> void:
	_current_delay = delay
	var actor := _turn_queue.get_current_actor() as Actor
	_actor_mover.move_actor(actor, target_pos)
	actor.pos = target_pos
	
	if _actor_list.player == actor:
		_visibility_map.call_deferred("update_fog", _actor_list.player.pos)
	
	_next_turn()


func _actor_attack(target_actor : Actor, damage : String, delay : float) -> void:
	_current_delay = delay
	target_actor.take_damage(max(0, Roll.from_string(damage) - target_actor.armor))
	var actor := _turn_queue.get_current_actor() as Actor
	_actor_attacker.attack_actor(actor, target_actor.pos)


func _actor_death(actor : Actor) -> void:
	pass
	#_current_delay = 1000
	#_turn_queue.remove_actor(actor)
	#_actor_list.remove(actor)


func _next_turn():
	_turn_queue.next_turn(_current_delay)
	var actor := _turn_queue.get_current_actor() as Actor
	actor.start_turn()
	
