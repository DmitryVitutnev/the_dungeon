extends TextureRect
class_name GridBackPack


var _items := []
var _grid := []
var _cell_size := 32
var _grid_width := 0
var _grid_height := 0


func _ready() -> void:
	var s = _get_grid_size(self)
	_grid_width = s.x
	_grid_height = s.y
	
	for x in range(_grid_width):
		_grid.append([])
		for y in range(_grid_height):
			_grid[x].append(false)


func insert_item(item):
	var item_pos = item.rect_global_position + Vector2(_cell_size / 2, _cell_size / 2)
	var g_pos = _pos_to_grid_coord(item_pos)
	var item_size = _get_grid_size(item)
	if _is_grid_space_available(g_pos.x, g_pos.y, item_size.x, item_size.y):
		_set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, true)
		item.rect_global_position = rect_global_position + g_pos * _cell_size
		_items.append(item)
		return true
	else:
		return false


func grab_item(pos : Vector2):
	var item = _get_item_under_pos(pos)
	if item == null:
		return null
	
	var item_pos = item.rect_global_position + Vector2(_cell_size / 2, _cell_size / 2)
	var g_pos = _pos_to_grid_coord(item_pos)
	var item_size = _get_grid_size(item)
	_set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, false)
	
	_items.remove(_items.find(item))
	return item


func insert_item_at_first_available_slot(item):
	for x in range(_grid_width):
		for y in range(_grid_height):
			if !_grid[x][y]:
				item.rect_global_position = rect_global_position + Vector2(x, y) * _cell_size
				if insert_item(item):
					return true
	return false

func _get_item_under_pos(pos : Vector2):
	for item in _items:
		if item.get_global_rect().has_point(pos):
			return item
	return null


func _set_grid_space(x, y, w, h, state) -> void:
	for i in range(x, x + w):
		for j in range(y, y + h):
			_grid[i][j] = state


func _is_grid_space_available(x : int, y : int, w : int, h : int) -> bool:
	if x < 0 or y < 0:
		return false
	if x + w > _grid_width or y + h > _grid_height:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if _grid[i][j]:
				return false
	return true


func _pos_to_grid_coord(pos) -> Vector2:
	var local_pos = pos - rect_global_position
	var results := Vector2()
	results.x = int(local_pos.x / _cell_size)
	results.y = int(local_pos.y / _cell_size)
	return results


func _get_grid_size(item) -> Vector2:
	var results := Vector2()
	var s = item.rect_size
	results.x = clamp(int(s.x / _cell_size), 1, 500)
	results.y = clamp(int(s.y / _cell_size), 1, 500)
	return results
