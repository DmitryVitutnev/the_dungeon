extends Node2D
class_name Actor


signal idle(delay)
signal move(target_pos, delay)
signal attack(target_actor, damage, delay)
signal health_changed(new_health)
signal death(actor)


export var starting_stats : Resource


var pos : Vector2
var dead := false


var _map : Map
var _actor_list : ActorList
var _equipped_items := {}
var _items := []


onready var stats := $Stats as ActorStats
onready var sound := $Sound as ActorSound
onready var appearance := $Appearance as ActorAppearance


func initialize(map : Map, actor_list : ActorList) -> void:
	stats.initialize(starting_stats)
	_map = map
	_actor_list = actor_list


func start_turn() -> void:
	pass


func take_damage(damage : int) -> void:
	stats.take_damage(damage)
	if stats.health <= 0:
		_die()
	else:
		sound.play_hit()


func pickup_item(item : Item) -> void:
	_items.append(item)


func equip_item(item : Item) -> void:
	_equipped_items[item.slot] = item
	appearance.set_texture(item.texture, item.slot)


func unequip_item(item : Item) -> void:
	if _equipped_items[item.slot] == item:
		_equipped_items.erase[item.slot] = null
		appearance.free_slot(item.slot)


func _die() -> void:
	dead = true
	appearance.set_dead()
	get_parent().move_child(self, 0)
	sound.play_kill()
	emit_signal("death", self)
