extends Node2D
class_name VisibilityMap


var _size : Vector2


onready var _tilemap := $TileMap as TileMap


func initialize(size : Vector2):
	_size = size
	for x in range(_size.x):
		for y in range(_size.y):
			_tilemap.set_cell(x, y, 0)


func update_fog(player_pos : Vector2):
	var player_center := player_pos * 32 + Vector2(16, 16)
	var space_state = get_world_2d().direct_space_state
	for x in range(_size.x):
		for y in range(_size.y):
			if _tilemap.get_cell(x, y) == 0:
				for x_dir in range(-1, 2, 2):
					for y_dir in range(-1, 2, 2):
						var test_point = Vector2(x, y) * 32 + Vector2(16, 16) + Vector2(x_dir, y_dir) * 16
						var occlusion = space_state.intersect_ray(player_center, test_point)
						if !occlusion or (occlusion.position - test_point).length() < 1:
							_tilemap.set_cell(x, y, -1)
							
				

