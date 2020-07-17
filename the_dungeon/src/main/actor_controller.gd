extends Node2D
class_name ActorController


const ACTION_IDLE_COST := 10
const ACTION_MOVE_COST := 20
const ACTION_ATTACK_COST := 20
const ACTION_SHOOT_COST := 20

# Temporal solution
var projectile_prefab = load("res://assets/items/projectiles/arrow_projectile.tscn")


var _map : Map
var _visibility_map : VisibilityMap


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
	actor.connect("action_shoot", self, "_actor_shoot")


func _remove_actor(actor : Actor) -> void:
	actor.disconnect("action_idle", self, "_actor_idle")
	actor.disconnect("action_move", self, "_actor_move")
	actor.disconnect("action_attack", self, "_actor_attack")
	actor.disconnect("action_shoot", self, "_actor_shoot")
	_turn_manager.remove_actor(actor)
	_actor_list.remove(actor)
	actor.get_parent().remove_child(actor)


func _actor_idle(actor : Actor) -> void:
	_next_turn(ACTION_IDLE_COST)


func _actor_move(actor : Actor, target_pos : Vector2) -> void:
	ActorMover.move_actor(actor, target_pos)
	actor.pos = target_pos
	
	if _actor_list.player == actor:
		_visibility_map.call_deferred("update_fog", _actor_list.player.pos)
	
	_next_turn(ACTION_MOVE_COST)


func _actor_attack(actor : Actor, target_actor : Actor, damage : String) -> void:
	#target_actor.take_damage(max(0, Roll.from_string(damage) - target_actor.armor))
	#ActorAttacker.attack_actor(actor, target_actor.pos)
	var forward_duration := 0.05
	var back_duration := 0.2
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(actor, "position",
		actor.pos * _map.TILE_SIZE, target_actor.pos * _map.TILE_SIZE, forward_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_callback(target_actor, forward_duration, "take_damage", max(0, Roll.from_string(damage) - target_actor.armor))
	tween.interpolate_property(actor, "position",
		target_actor.pos * _map.TILE_SIZE, actor.pos * _map.TILE_SIZE, back_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, forward_duration)
	tween.interpolate_callback(self, forward_duration + back_duration, "_next_turn", ACTION_ATTACK_COST)
	tween.interpolate_callback(tween, forward_duration + back_duration, "queue_free")
	tween.start()


func _actor_shoot(actor : Actor, target_actor : Actor, damage : String) -> void:
	var target_point = Vector2(rand_range(-4, 4), rand_range(-4, 4))
	var start_point = (actor.pos - target_actor.pos) * _map.TILE_SIZE + Vector2(rand_range(-4, 4), rand_range(-4, 4))
	var flight_duration = (target_point - start_point).length() * 0.005
	var projectile = projectile_prefab.instance()
	target_actor._appearance.impaled.add_child(projectile)
	projectile.rotation = (target_point - start_point).angle()
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(projectile, "position",
		start_point, target_point, flight_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_callback(target_actor, flight_duration, "take_damage", 
	max(0, Roll.from_string(damage) - target_actor.armor))
	tween.interpolate_callback(self, flight_duration, "_next_turn", ACTION_SHOOT_COST)
	tween.interpolate_callback(tween, flight_duration, "queue_free")
	tween.start()


func _next_turn(energy_loss : int):
	if !_actor_list.player.dead:
		_turn_manager.end_turn(energy_loss)
	
