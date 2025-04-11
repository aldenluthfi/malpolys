extends TileMapLayer

var _rng

@onready var grass_tiles = [
	Vector2i(0, 3),
	Vector2i(1, 3),
	Vector2i(2, 3),
	Vector2i(3, 3),
	Vector2i(0, 4),
	Vector2i(1, 7)
]

@onready var path_tiles = [
	Vector2i(4, 5),
	Vector2i(6, 5),
	Vector2i(7, 5)
]

func _ready():
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

func generate(
		x_offset: int,
		y_offset: int,
		rotations: int
	) -> Array:

	var spawner = false
	var starts = []
	var ends = []

	var center_start = Vector2i(0, 6)
	var left_start = Vector2i(6, 12)
	var right_start = Vector2i(6, 0)

	var end = Vector2i(12, 6)

	var center_connect = Vector2i(-1, 6) + Vector2i(x_offset, y_offset)
	var left_connect = Vector2i(6, 13) + Vector2i(x_offset, y_offset)
	var right_connect = Vector2i(6, -1) + Vector2i(x_offset, y_offset)

	var end_connect = Vector2i(13, 6) + Vector2i(x_offset, y_offset)

	for i in range(rotations % 4):
		var temp_left_start = left_start
		left_start = center_start
		center_start = right_start
		right_start = end
		end = temp_left_start

		var temp_left_connect = left_connect
		left_connect = center_connect
		center_connect = right_connect
		right_connect = end_connect
		end_connect = temp_left_connect

	var center_opening = get_cell_atlas_coords(center_connect)
	var left_opening = get_cell_atlas_coords(left_connect)
	var right_opening = get_cell_atlas_coords(right_connect)

	var right_states = [right_opening in grass_tiles, right_opening in path_tiles]
	var left_states = [left_opening in grass_tiles, left_opening in path_tiles]
	var center_states = [center_opening in grass_tiles, center_opening in path_tiles]

	var states = left_states + center_states + right_states

	if states == [false, false, false, false, false, false]:
		starts = [
			[left_start, false][_rng.randi_range(0, 1)],
			center_start,
			[right_start, false][_rng.randi_range(0, 1)]
		]
		ends = [end, end, end]

	if states == [false, false, false, false, false, true]:
		starts = [center_start, left_start]
		ends = [right_start, end]

	if states == [false, false, false, false, true, false]:
		starts = [[left_start, false][_rng.randi_range(0, 1)], center_start]
		ends = [end, end]

	if states == [false, false, false, true, false, false]:
		starts = [right_start, left_start]
		ends = [center_start, end]

	if states == [false, false, false, true, false, true]:
		starts = [left_start, left_start, left_start]
		ends = [end, right_start, center_start]

	if states == [false, false, false, true, true, false]:
		starts = [left_start, left_start]
		ends = [center_start, end]

	if states == [false, false, true, false, false, false]:
		starts = [[left_start, false][_rng.randi_range(0, 1)], right_start]
		ends = [end, end]

	if states == [false, false, true, false, false, true]:
		starts = [left_start, left_start]
		ends = [end, right_start]

	if states == [false, false, true, false, true, false]:
		starts = [left_start]
		ends = [end]

	if states == [false, true, false, false, false, false]:
		starts = [center_start, right_start]
		ends = [left_start, end]

	if states == [false, true, false, false, false, true]:
		starts = [center_start, center_start, center_start]
		ends = [left_start, end, right_start]

	if states == [false, true, false, false, true, false]:
		starts = [center_start, center_start]
		ends = [left_start, end]

	if states == [false, true, false, true, false, false]:
		starts = [right_start, right_start, right_start]
		ends = [left_start, end, center_start]

	if states == [false, true, false, true, false, true]:
		starts = [Vector2i(6, 6), Vector2i(6, 6), Vector2i(6, 6), Vector2i(6, 6)]
		ends = [left_start, end, center_start, right_start]
		spawner = true

	if states == [false, true, false, true, true, false]:
		starts = [Vector2i(6, 6), Vector2i(6, 6), Vector2i(6, 6)]
		ends = [left_start, end, center_start]
		spawner = true

	if states == [false, true, true, false, false, false]:
		starts = [right_start, right_start]
		ends = [left_start, end]

	if states == [false, true, true, false, false, true]:
		starts = [Vector2i(6, 6), Vector2i(6, 6), Vector2i(6, 6)]
		ends = [left_start, end, right_start]
		spawner = true

	if states == [false, true, true, false, true, false]:
		starts = [Vector2i(6, 6), Vector2i(6, 6)]
		ends = [left_start, end]
		spawner = true

	if states == [true, false, false, false, false, false]:
		starts = [center_start, [right_start, false][_rng.randi_range(0, 1)]]
		ends = [end, end]

	if states == [true, false, false, false, false, true]:
		starts = [center_start, center_start]
		ends = [end, right_start]

	if states == [true, false, false, false, true, false]:
		starts = [center_start]
		ends = [end]

	if states == [true, false, false, true, false, false]:
		starts = [right_start, right_start]
		ends = [end, center_start]

	if states == [true, false, false, true, false, true]:
		starts = [Vector2i(6, 6), Vector2i(6, 6), Vector2i(6, 6)]
		ends = [end, center_start, right_start]
		spawner = true

	if states == [true, false, false, true, true, false]:
		starts = [Vector2i(6, 6), Vector2i(6, 6)]
		ends = [end, center_start]
		spawner = true

	if states == [true, false, true, false, false, false]:
		starts = [right_start]
		ends = [end]

	if states == [true, false, true, false, false, true]:
		starts = [Vector2i(6, 6), Vector2i(6, 6)]
		ends = [end, right_start]
		spawner = true

	if states == [true, false, true, false, true, false]:
		starts = [Vector2i(6, 6)]
		ends = [end]
		spawner = true

	var grid = generate_graph()
	var paths = []

	for i in range(starts.size()):
		var s = starts[i]
		var e = ends[i]

		if s is bool and s == false:
			continue

		var path = find_shortest_path(grid, s, e)
		paths.append(path)

	for i in range(grid.size()):
		for j in range(grid[0].size()):
			var tile

			if grid[i][j] > 6:
				tile = grass_tiles[_rng.randi_range(1, 6) - 1]
			else:
				tile = grass_tiles[grid[i][j] - 1]

			self.set_cell(Vector2i(i + x_offset, j + y_offset), 3, tile, 0)

	for path in paths:
		for pos in range(path.size()):
			path[pos] += Vector2i(x_offset, y_offset)
			self.set_cell(path[pos], 3, Vector2i(4, 5))
		self.set_cells_terrain_connect(path, 0, 0)

	var expansions = []
	for expansion in [[left_connect, 3], [center_connect, 0], [right_connect, 1]]:
		var tile = self.get_cell_atlas_coords(expansion[0])

		if tile == Vector2i(-1, -1):
			continue

		expansions.append(expansion)

	return [
		expansions,
		paths,
		Vector2i(6 + x_offset, 6 + y_offset) if spawner else Vector2i(-1, -1)
	]

func generate_graph() -> Array:
	var grid = []

	for i in range(13):
		var row = []
		for j in range(13):
			if j == 0 or j == 12 or i == 0 or i == 12:
				row.append(100)  # Set borders to 0
			else:
				row.append(_rng.randi_range(1, 6))
		grid.append(row)

	return grid

func find_shortest_path(grid: Array, start: Vector2i, end: Vector2i) -> Array:
	var rows = grid.size()
	var cols = grid[0].size()

	# Priority queue for Dijkstra's algorithm (distance, position)
	# GDScript doesn't have a heap, so we'll implement a simple priority queue
	var pq = PriorityQueue.new()
	pq.push(0, start)

	# distances[i][j] = shortest known distance from start to (i, j)
	var distances = []
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(INF)
		distances.append(row)
	distances[start.x][start.y] = 0

	# previous[i][j] = where we came from to get to (i, j)
	var previous = []
	for i in range(rows):
		var row = []
		for j in range(cols):
			row.append(null)
		previous.append(row)

	# Possible moves: right, left, down, up
	var directions = [
		Vector2i(0, 1),
		Vector2i(0, -1),
		Vector2i(1, 0),
		Vector2i(-1, 0)
	]

	while not pq.is_empty():
		var item = pq.pop()
		var distance = item[0]
		var pos = item[1]
		var row = pos.x
		var col = pos.y

		if Vector2i(row, col) == end:
			break

		if distance > distances[row][col]:
			continue

		for dir in directions:
			var nrow = row + dir.x
			var ncol = col + dir.y

			if nrow >= 0 and nrow < rows and ncol >= 0 and ncol < cols:
				var new_distance = distance + grid[nrow][ncol]

				if new_distance < distances[nrow][ncol]:
					distances[nrow][ncol] = new_distance
					previous[nrow][ncol] = Vector2i(row, col)
					pq.push(new_distance, Vector2i(nrow, ncol))

	# Reconstruct the center_path
	var path = []
	var current = end

	while current != null:
		path.append(current)
		if current.x < 0 or current.y < 0:
			break  # Safety check
		current = previous[current.x][current.y]

	path.reverse()
	return path

# Custom priority queue implementation
class PriorityQueue:
	var elements = []

	func push(priority, item):
		elements.append([priority, item])
		sort_elements()

	func pop():
		if elements.size() > 0:
			return elements.pop_front()
		return null

	func is_empty():
		return elements.size() == 0

	func sort_elements():
		elements.sort_custom(Callable(self, "compare_elements"))

	func compare_elements(a, b):
		return a[0] < b[0]
