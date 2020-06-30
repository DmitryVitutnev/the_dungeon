extends Node2D
class_name Actor


signal action_idle(delay)
signal action_move(target_pos, delay)
signal action_attack(target_actor, damage, delay)
signal death(actor)
signal stats_changed()


export var starting_stats : Resource


var pos : Vector2
var dead : bool setget , _is_dead
var health : int setget _set_health, _get_health
var max_health : int setget , _get_max_health
var damage : String setget , _get_damage
var armor : int setget , _get_armor
var speed : int setget , _get_speed


var _map : Map
var _actor_list : ActorList
var _equipped_items := {}
var _items := []


onready var _stats := $Stats as ActorStats
onready var _sound := $Sound as ActorSound
onready var _appearance := $Appearance as ActorAppearance


func initialize(map : Map, actor_list : ActorList) -> void:
	_stats.initialize(starting_stats)
	_map = map
	_actor_list = actor_list
	
	health = _get_max_health()


func start_turn() -> void:
	pass


func take_damage(damage : int) -> void:
	_set_health(_get_health() - damage)
	if _get_health() <= 0:
		_die()
	else:
		_sound.play_hit()


func pickup_item(item : Item) -> void:
	_items.append(item)


func equip_item(item : Item) -> void:
	_equipped_items[item.slot] = item
	_appearance.set_texture(item.texture, item.slot)


func unequip_item(item : Item) -> void:
	if _equipped_items[item.slot] == item:
		_equipped_items.erase[item.slot] = null
		_appearance.free_slot(item.slot)


func _die() -> void:
	_appearance.set_dead()
	get_parent().move_child(self, 0)
	_sound.play_kill()
	emit_signal("death", self)


func _is_dead() -> bool:
	return _get_health() <= 0


func _set_health(value : int) -> void:
	health = value
	emit_signal("stats_changed")


func _get_health() -> int:
	var result := health
	return result


func _get_max_health() -> int:
	var result := _stats.max_health
	for i in _equipped_items.values():
		var item := i as Item
		result += item.max_health
	return result


func _get_damage() -> String:
	var result := _stats.damage
	for i in _equipped_items.values():
		var item := i as Item
		result += "+" + item.damage
	return result


func _get_armor() -> int:
	var result := _stats.armor
	for i in _equipped_items.values():
		var item := i as Item
		result += item.armor
	return result


func _get_speed() -> int:
	var result := _stats.speed
	for i in _equipped_items.values():
		var item := i as Item
		result += item.speed
	return result
