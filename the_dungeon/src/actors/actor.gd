extends Node2D
class_name Actor


signal action_idle(delay)
signal action_move(target_pos, delay)
signal action_attack(target_actor, damage, delay)

signal death(actor)
signal stats_changed(actor)
signal pos_changed(actor)
signal item_picked_up(item)
signal item_dropped(item, pos)


export var starting_stats : Resource


var damage_popup = load("res://src/utils/damage_popup.tscn")


var pos : Vector2 setget _set_pos
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
	var pop := damage_popup.instance() as DamagePopup
	pop.amount = damage
	pop.position = Vector2(16, -8)
	add_child(pop)
	if _get_health() <= 0:
		_die()
	else:
		_sound.play_hit()


func pickup_item(item : Item) -> void:
	_items.append(item)
	emit_signal("item_picked_up", item)


func drop_item(item : Item) -> void:
	_items.erase(item)
	emit_signal("item_dropped", item, pos)


func equip_item(item : Item) -> void:
	_equipped_items[item.slot] = item
	_appearance.set_item_in_slot(item, item.slot)
	item.connect("taken", self, "unequip_item")


func unequip_item(item : Item) -> void:
	_equipped_items.erase(item.slot)
	_appearance.free_slot(item.slot)
	item.disconnect("taken", self, "unequip_item")


func _set_pos(new_pos : Vector2) -> void:
	pos = new_pos
	emit_signal("pos_changed", self)


func _die() -> void:
	var items_to_drop = [] + _items
	for i in items_to_drop:
		drop_item(i)
	_appearance.set_dead()
	get_parent().move_child(self, 0)
	_sound.play_kill()
	emit_signal("death", self)


func _is_dead() -> bool:
	return _get_health() <= 0


func _set_health(value : int) -> void:
	health = value
	emit_signal("stats_changed", self)


func _get_health() -> int:
	var result := health
	return result


func _get_max_health() -> int:
	var result := _stats.max_health
	for i in _equipped_items.values():
		var item := i as Item
		result += item.max_health
	if result < 0:
		result = 0
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
	if result < 0:
		result = 0
	return result


func _get_speed() -> int:
	var result := _stats.speed
	for i in _equipped_items.values():
		var item := i as Item
		result += item.speed
	if result < 1:
		result = 1
	return result
