extends Node2D
class_name Map


const TILE_SIZE: int = 32
const MIN_ROOM_DIMENSION: int = 5
const MAX_ROOM_DIMENSION: int = 8
enum Tile {WALL, DOOR, EXIT, FLOOR, STONE}


var size : Vector2 
var exit_pos : Vector2


var _map := []
var _rooms := []
var _pathfinding_graph := AStar2D.new()
var _id_array := []


onready var _tile_map := $TileMap as TileMap


func is_free(pos: Vector2):
	return _map[pos.x][pos.y] == Tile.FLOOR or _map[pos.x][pos.y] == Tile.EXIT


func pos_to_coord(pos : Vector2) -> Vector2:
	return position + pos * TILE_SIZE


func find_path(from : Vector2, to : Vector2) -> PoolVector2Array:
	var id_from = _pathfinding_graph.get_closest_point(from)
	var id_to = _pathfinding_graph.get_closest_point(to)
	return _pathfinding_graph.get_point_path(id_from, id_to)


func line_is_free(from : Vector2, to : Vector2) -> bool:
	var steps_num := max(abs(to.x - from.x), abs(to.y - from.y))
	for i in range(steps_num):
		var point = from * (1 - i / steps_num) + to * i / steps_num
		if !is_free(Vector2(floor(point.x), floor(point.y))):
			return false
	return true


func build_level(map_size : Vector2, room_number : int) -> void:
	_rooms.clear()
	_map.clear()
	_tile_map.clear()
	_pathfinding_graph.clear()
	_id_array.clear()
	
	size = map_size
	for x in range(size.x):
		_map.append([])
		for y in range(size.y):
			_map[x].append(Tile.STONE);
			_set_tile(x, y, Tile.STONE)
	
	var free_regions := [Rect2(Vector2(2, 2), size - Vector2(4, 4))]
	for i in range(room_number):
		_add_room(free_regions)
		if free_regions.empty():
			break;
	_connect_room()
	_place_exit()
	
	_build_pathfinding_graph()


func generate_player_pos() -> Vector2:
	var room = _rooms.front()
	var x = room.position.x + 1 + randi() % int(room.size.x - 2)
	var y = room.position.y + 1 + randi() % int(room.size.y - 2)
	return Vector2(x, y)


func generate_enemy_pos() -> Vector2:
	var room = _rooms[1 + randi() % int(_rooms.size() - 1)]
	var x = room.position.x + 1 + randi() % int(room.size.x - 2)
	var y = room.position.y + 1 + randi() % int(room.size.y - 2)
	return Vector2(x, y)


func _set_tile(x : int, y : int, type : int) -> void:
	_map[x][y] = type;
	_tile_map.set_cell(x, y, type)


func _add_room(free_regions : Array) -> void:
	var region: Rect2 = free_regions[randi() % free_regions.size()]
	
	var size_x :int= MIN_ROOM_DIMENSION
	if region.size.x > MIN_ROOM_DIMENSION:
		size_x += randi() % int(region.size.x - MIN_ROOM_DIMENSION)
	
	var size_y :int= MIN_ROOM_DIMENSION
	if region.size.y > MIN_ROOM_DIMENSION:
		size_y += randi() % int(region.size.y - MIN_ROOM_DIMENSION)
	
	size_x = min(size_x, MAX_ROOM_DIMENSION)
	size_y = min(size_y, MAX_ROOM_DIMENSION)
	
	var start_x := region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
	
	var start_y := region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
		
	
	var room = Rect2(start_x, start_y, size_x, size_y)
	_rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		_set_tile(x, start_y, Tile.WALL)
		_set_tile(x, start_y + size_y - 1, Tile.WALL)
	
	for y in range(start_y + 1, start_y + size_y - 1):
		_set_tile(start_x, y, Tile.WALL)
		_set_tile(start_x + size_x - 1, y, Tile.WALL)
		
		for x in range(start_x + 1, start_x + size_x - 1):
			_set_tile(x, y, Tile.FLOOR)
	
	_cut_regions(free_regions, room)


func _cut_regions(free_regions : Array, region_to_remove : Rect2) -> void:
	var removal_queue := []
	var addition_queue := []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left := int(region_to_remove.position.x - region.position.x - 1)
			var leftover_right := int(region.end.x - region_to_remove.end.x - 1)
			var leftover_above := int(region_to_remove.position.y - region.position.y - 1)
			var leftover_below := int(region.end.y - region_to_remove.end.y - 1)
			
			if leftover_left >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= MIN_ROOM_DIMENSION:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
			
	for region in removal_queue:
		free_regions.erase(region)
	
	for region in addition_queue:
		free_regions.append(region)


func _connect_room() -> void:
	# Build AStar graph of area where can build corridors
	
	var stone_graph := AStar2D.new()
	var point_id := 0
	for x in range(size.x):
		for y in range(size.y):
			if _map[x][y] == Tile.STONE:
				stone_graph.add_point(point_id, Vector2(x, y))
				
				# Connect to left if also stone
				if x > 0 and _map[x - 1][y] == Tile.STONE:
					var left_point := stone_graph.get_closest_point(Vector2(x - 1, y))
					stone_graph.connect_points(point_id, left_point)
				
				# Connect to above if also stone
				if y > 0 and _map[x][y - 1] == Tile.STONE:
					var above_point := stone_graph.get_closest_point(Vector2(x, y - 1))
					stone_graph.connect_points(point_id, above_point)
				
				point_id += 1
	
	# Build AStar graph of room connections
	
	var room_graph = AStar2D.new()
	point_id = 0
	for room in _rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id, Vector2(room_center.x, room_center.y))
		point_id += 1
	
	# Add random connections until everything is connected
	
	while !_is_everything_connected(room_graph):
		_add_random_connection(stone_graph, room_graph)


func _is_everything_connected(graph : AStar2D) -> bool:
	var points := graph.get_points()
	var start: int = points.pop_back()
	for point in points:
		var path := graph.get_point_path(start, point)
		if !path:
			return false
	return true


func _add_random_connection(stone_graph : AStar2D, room_graph : AStar2D) -> void:
	# Pick rooms to connect
	
	var start_room_id := _get_least_connected_point(room_graph)
	var end_room_id := _get_nearest_unconnected_point(room_graph, start_room_id)
	
	# Pick door locations
	
	var start_position := _pick_random_door_location(_rooms[start_room_id])
	var end_position := _pick_random_door_location(_rooms[end_room_id])
	
	# Find a path to connect the doors to each other
	
	var closest_start_point := stone_graph.get_closest_point(start_position)
	var closest_end_point := stone_graph.get_closest_point(end_position)
	
	var path := stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	# Add path to the map
	
	#_set_tile(start_position.x, start_position.y, Tile.DOOR)
	#_set_tile(end_position.x, end_position.y, Tile.DOOR)
	_set_tile(start_position.x, start_position.y, Tile.FLOOR)
	_set_tile(end_position.x, end_position.y, Tile.FLOOR)
	
	for position in path:
		_set_tile(position.x, position.y, Tile.FLOOR)
	
	room_graph.connect_points(start_room_id, end_room_id)


func _get_least_connected_point(graph : AStar2D) -> int:
	var point_ids := graph.get_points()
	
	var least
	var tied_for_least := []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		if !least or count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
	
	return tied_for_least[randi() % tied_for_least.size()]


func _get_nearest_unconnected_point(graph : AStar2D, target_point : int) -> int:
	var target_position := graph.get_point_position(target_point)
	var point_ids := graph.get_points()
	
	var nearest
	var tied_for_nearest := []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path := graph.get_point_path(point, target_point)
		if path:
			continue
		
		var dist := (graph.get_point_position(point) - target_position).length()
		if !nearest or dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
	
	return tied_for_nearest[randi() % tied_for_nearest.size()]


func _pick_random_door_location(room : Rect2) -> Vector2:
	var options := []
	
	# Top and bottom walls
	
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector2(x, room.position.y))
		options.append(Vector2(x, room.end.y - 1))
	
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector2(room.position.x, y))
		options.append(Vector2(room.end.x - 1, y))
	
	return options[randi() % options.size()]


func _place_exit() -> void:
	var room = _rooms.back()
	var x = room.position.x + 1 + randi() % int(room.size.x - 2)
	var y = room.position.y + 1 + randi() % int(room.size.y - 2)
	_set_tile(x, y, Tile.EXIT)
	exit_pos = Vector2(x, y)


func _build_pathfinding_graph():
	_id_array.clear()
	var id := 1
	for x in range(size.x):
		_id_array.append([])
		for y in range(size.y):
			if is_free(Vector2(x, y)):
				_id_array[x].append(id)
				_pathfinding_graph.add_point(id, Vector2(x,y))
				id += 1
			else:
				_id_array[x].append(0)
	
	for x in range(1, size.x):
		for y in range(size.y):
			var id1 = _id_array[x - 1][y]
			var id2 = _id_array[x][y]
			if id1 != 0 and id2 != 0:
				_pathfinding_graph.connect_points(id1, id2)
	
	for x in range(size.x):
		for y in range(1, size.y):
			var id1 = _id_array[x][y - 1]
			var id2 = _id_array[x][y]
			if id1 != 0 and id2 != 0:
				_pathfinding_graph.connect_points(id1, id2)
