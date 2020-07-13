extends Node2D
class_name ActorController


const ACTION_IDLE_COST := 10
const ACTION_MOVE_COST := 20
const ACTION_ATTACK_COST := 20


var _map : Map
var _visibility_map : VisibilityMap
var _current_energy_loss := 0


onready var _actor_list := $ActorList as ActorList
onready var _turn_manager := $TurnManager as TurnManager


func _ready():
	ActorAttacker.connect("finished", self, "_next_turn")


func initialize(map : Map, visibility_map : VisibilityMap) -> void:
	_map = map
	_visibility_map = visibility_map


func start_game() -> void:
	_turn_manager.start()


func add_player(player : PlayerActor) -> void:
	var pos = _map.generate_player_pos()
	player.pos = pos
	player.position = 32 * pos
	_actor_list.player = player
	
	_add_actor(player)


func add_enemy(enemy : Actor) -> void:
	var pos = _map.generate_enemy_pos()
	while _actor_list.get_alive_actor_by_pos(pos) != null:
		pos = _map.generate_enemy_pos()
	_actor_list.add_enemy(enemy)
	enemy.initialize(_map, _actor_list)
	enemy.pos = pos
	enemy.position = 32 * pos
	
	_add_actor(enemy)


func clear() -> void:
	_turn_manager.clear()
	_actor_list.clear_enemies()
	ActorMover.clear()
	ActorAttacker.clear()


func _add_actor(actor : Actor) -> void:
	_turn_manager.add_actor(actor)
	actor.connect("action_idle", self, "_actor_idle")
	actor.connect("action_move", self, "_actor_move")
	actor.connect("action_attack", self, "_actor_attack")


func _remove_actor(actor : Actor) -> void:
	actor.disconnect("action_idle", self, "_actor_idle")
	actor.disconnect("action_move", self, "_actor_move")
	actor.disconnect("action_attack", self, "_actor_attack")
	_turn_manager.remove_actor(actor)
	_actor_list.remove(actor)
	actor.get_parent().remove_child(actor)


func _actor_idle(actor : Actor) -> void:
	_current_energy_loss = ACTION_IDLE_COST
	_next_turn()


func _actor_move(actor : Actor, target_pos : Vector2) -> void:
	_current_energy_loss = ACTION_MOVE_COST
	ActorMover.move_actor(actor, target_pos)
	actor.pos = target_pos
	
	if _actor_list.player == actor:
		_visibility_map.call_deferred("update_fog", _actor_list.player.pos)
	
	_next_turn()


func _actor_attack(actor : Actor, target_actor : Actor, damage : String) -> void:
	_current_energy_loss = ACTION_ATTACK_COST
	target_actor.take_damage(max(0, Roll.from_string(damage) - target_actor.armor))
	ActorAttacker.attack_actor(actor, target_actor.pos)


func _next_turn():
	if !_actor_list.player.dead:
		_turn_manager.end_turn(_current_energy_loss)
	
