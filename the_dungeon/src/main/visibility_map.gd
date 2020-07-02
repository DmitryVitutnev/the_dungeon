extends Node2D
class_name VisibilityMap


const VIEWPORT_DISTANCE := Vector2(12, 8)


var _size : Vector2
var _map : Map


onready var _tilemap := $TileMap as TileMap


func initialize(map : Map) -> void:
	_map = map


func reset(size : Vector2):
	_size = size
	_tilemap.clear()
	for x in range(-VIEWPORT_DISTANCE.x, _size.x + VIEWPORT_DISTANCE.x + 1, 1):
		for y in range(-VIEWPORT_DISTANCE.y, _size.y + VIEWPORT_DISTANCE.y + 1, 1):
			_tilemap.set_cell(x, y, 0)


func update_fog(player_pos : Vector2):
	var space_state = get_world_2d().direct_space_state
	var start_pos := Vector2(max(0, player_pos.x - VIEWPORT_DISTANCE.x), max(0, player_pos.y - VIEWPORT_DISTANCE.y))
	var end_pos := Vector2(min(_size.x - 1, player_pos.x + VIEWPORT_DISTANCE.x), min(_size.y, player_pos.y + VIEWPORT_DISTANCE.y))
	for x in range(start_pos.x, end_pos.x + 1, 1):
		for y in range(start_pos.y, end_pos.y + 1, 1):
			_tilemap.set_cell(x, y, 0)
			if _tilemap.get_cell(x, y) == 0:
				for x_dir in range(-1, 2, 2):
					for y_dir in range(-1, 2, 2):
						for p_x_dir in range (-1, 2, 2):
							for p_y_dir in range (-1, 2, 2):
								var test_point = Vector2(x, y) * 32 + Vector2(16, 16) + Vector2(x_dir, y_dir) * 16
								var player_point := player_pos * 32 + Vector2(16, 16) + Vector2(p_x_dir, p_y_dir) * 4
								var occlusion = space_state.intersect_ray(player_point, test_point)
								if !occlusion or (occlusion.position - test_point).length() < 2:
									_tilemap.set_cell(x, y, -1)

