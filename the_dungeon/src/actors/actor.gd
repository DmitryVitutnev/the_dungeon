extends Node2D
class_name Actor


signal action_idle(actor, action_cost)
signal action_move(actor, action_cost, target_pos)
signal action_attack(actor, action_cost, target_actor)
signal action_shoot(actor, action_cost, target_actor, projectile_scene)

signal death(actor)
signal stats_changed(actor)
signal pos_changed(actor)
signal item_picked_up(item)
signal item_dropped(item, pos)


const MOVEMENT_COST = 6
const IDLE_COST = 1


export var starting_stats : Resource
var fist_weapon_res := preload("res://assets/items/utils/fist.tres") as WeaponItemRes


var damage_popup = load("res://src/utils/damage_popup.tscn")


var in_animation := false
var pos : Vector2 setget _set_pos
var dead : bool setget , _is_dead
var health : int setget _set_health, _get_health
var max_health : int setget , _get_max_health
var min_damage : int setget , _get_min_damage
var max_damage : int setget , _get_max_damage
var attack_cost : int setget , _get_attack_cost
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
	item.emit_signal("taken", item)


func drop_item(item : Item) -> void:
	_items.erase(item)
	emit_signal("item_dropped", item, pos)


func equip_item(item : EquipableItem) -> bool:
	if _equipped_items.keys().has(item.slot):
		return false
	if item.slot == Enum.EquipmentSlot.TWO_HANDS:
		if _equipped_items.has(Enum.EquipmentSlot.MAIN_HAND) or _equipped_items.has(Enum.EquipmentSlot.OFF_HAND):
			return false
	if item.slot == Enum.EquipmentSlot.MAIN_HAND or item.slot == Enum.EquipmentSlot.OFF_HAND:
		if _equipped_items.has(Enum.EquipmentSlot.TWO_HANDS):
			return false
	_equipped_items[item.slot] = item
	_appearance.set_item_in_slot(item, item.slot)
	print(item.slot)
	item.connect("taken", self, "unequip_item")
	emit_signal("stats_changed", self)
	return true


func unequip_item(item : EquipableItem) -> bool:
	if !_equipped_items.values().has(item):
		return false
	_equipped_items.erase(item.slot)
	_appearance.free_slot(item.slot)
	item.disconnect("taken", self, "unequip_item")
	emit_signal("stats_changed", self)
	return true


func _is_ranged() -> bool:
	return _equipped_items.has(Enum.EquipmentSlot.TWO_HANDS) and _equipped_items[Enum.EquipmentSlot.TWO_HANDS] is RangedWeaponItem


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
	if result < 0:
		result = 0
	return result


func _get_min_damage() -> int:
	var result := 0
	if _equipped_items.has(Enum.EquipmentSlot.MAIN_HAND):
		var weapon := _equipped_items[Enum.EquipmentSlot.MAIN_HAND] as WeaponItem
		result += weapon.min_damage
	if _equipped_items.has(Enum.EquipmentSlot.TWO_HANDS):
		var weapon := _equipped_items[Enum.EquipmentSlot.TWO_HANDS] as WeaponItem
		result += weapon.min_damage
	if _equipped_items.has(Enum.EquipmentSlot.OFF_HAND) and _equipped_items[Enum.EquipmentSlot.OFF_HAND] is WeaponItem:
		var weapon := _equipped_items[Enum.EquipmentSlot.OFF_HAND] as WeaponItem
		result += weapon.min_damage
	if result == 0:
		result = fist_weapon_res.min_damage
	return result


func _get_max_damage() -> int:
	var result := 0
	if _equipped_items.has(Enum.EquipmentSlot.MAIN_HAND):
		var weapon := _equipped_items[Enum.EquipmentSlot.MAIN_HAND] as WeaponItem
		result += weapon.max_damage
	if _equipped_items.has(Enum.EquipmentSlot.TWO_HANDS):
		var weapon := _equipped_items[Enum.EquipmentSlot.TWO_HANDS] as WeaponItem
		result += weapon.max_damage
	if _equipped_items.has(Enum.EquipmentSlot.OFF_HAND) and _equipped_items[Enum.EquipmentSlot.OFF_HAND] is WeaponItem:
		var weapon := _equipped_items[Enum.EquipmentSlot.OFF_HAND] as WeaponItem
		result += weapon.max_damage
	if result == 0:
		result = fist_weapon_res.max_damage
	return result


func _get_attack_cost() -> int:
	var result := 0
	if _equipped_items.has(Enum.EquipmentSlot.MAIN_HAND):
		var weapon := _equipped_items[Enum.EquipmentSlot.MAIN_HAND] as WeaponItem
		result += weapon.attack_cost
	if _equipped_items.has(Enum.EquipmentSlot.TWO_HANDS):
		var weapon := _equipped_items[Enum.EquipmentSlot.TWO_HANDS] as WeaponItem
		result += weapon.attack_cost
	if _equipped_items.has(Enum.EquipmentSlot.OFF_HAND) and _equipped_items[Enum.EquipmentSlot.OFF_HAND] is WeaponItem:
		var weapon := _equipped_items[Enum.EquipmentSlot.OFF_HAND] as WeaponItem
		result += weapon.attack_cost
	if result == 0:
		result = fist_weapon_res.attack_cost
	return result


func _get_armor() -> int:
	var result := _stats.armor
	for i in _equipped_items.values():
		if i is ArmorItem:
			var item := i as ArmorItem
			result += item.armor
	if result < 0:
		result = 0
	return result


func _get_speed() -> int:
	var result := _stats.speed
	return result
