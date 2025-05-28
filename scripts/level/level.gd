extends "res://scripts/misc/globals.gd"

@onready var tile_map = $tile_set
@onready var above_tiles = $towers
@onready var hud = $gui/hud

@export var expand_button: PackedScene

var _current_wave = 0
var _wave_enemies = []
var _tower_preview: Variant = null

var _money = 20
var _lives = 20

var _rng

var wave = 1
var tower_edited: Variant

var coords_to_towers = {}
var towers_to_coords = {}


var paths = [
	[
		Vector2i(-6, 0),
		Vector2i(-5, 0),
		Vector2i(-4, 0),
		Vector2i(-3, 0),
		Vector2i(-2, 0),
		Vector2i(-1, 0),
		Vector2i(0, 0),
		Vector2i(1, 0)
	]
]
var expansion_points = []

const cardinal_directions = [
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1)
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

	tile_map.set_cells_terrain_connect([Vector2i(-6, 0)], 0, 0)
	var initial_expand = expand_button.instantiate()
	initial_expand.process_mode = Node.PROCESS_MODE_PAUSABLE

	initial_expand.position = tile_isometric_to_cartesian(
		Vector2i(-6, 0)
	) + Vector2i(0, -8)
	initial_expand.coords = Vector2i(-6, -6)
	initial_expand.rotate = 0

	expansion_points.append(initial_expand)
	add_child(initial_expand)

	update_money(0)
	update_lives(0)
	update_wave_label()

func expand(coords: Vector2i, rotation_index: int) -> void:

	if rotation_index == 0:
		coords += Vector2i(-13, 0)
	if rotation_index == 1:
		coords += Vector2i(0, -13)
	if rotation_index == 2:
		coords += Vector2i(13, 0)
	if rotation_index == 3:
		coords += Vector2i(0, 13)

	var expansions = tile_map.generate(
		coords.x,
		coords.y,
		rotation_index
	)

	for point in expansions[0]:
		var expansion = expand_button.instantiate()
		expansion.process_mode = Node.PROCESS_MODE_PAUSABLE

		expansion.position = tile_isometric_to_cartesian(
			point[0] + Vector2i(1, 0)
		) + Vector2i(0, -8)
		expansion.coords = coords
		expansion.rotate = (rotation_index + point[1]) % 4

		expansion_points.append(expansion)
		add_child(expansion)

	var new_points = []
	for point in expansion_points:
		var loc = point.coords
		if point.rotate == 0:
			loc += Vector2i(-13, 0)
		if point.rotate == 1:
			loc += Vector2i(0, -13)
		if point.rotate == 2:
			loc += Vector2i(13, 0)
		if point.rotate == 3:
			loc += Vector2i(0, 13)

		if tile_map.get_cell_atlas_coords(loc) != Vector2i(-1, -1):
			point.queue_free()
			continue

		new_points.append(point)
	expansion_points = new_points


	var new_paths = []
	for path in paths:
		var connected = false

		for new_path in expansions[1]:
			if new_path[-1].distance_to(path[0]) == 1:
				new_paths.append(new_path + path)
				connected = true

		if not connected:
			new_paths.append(path)
	paths = new_paths

	if expansions[2] != Vector2i(-1, -1):
		above_tiles.set_cell(expansions[2], 3, Vector2i(12, 18))
		above_tiles.set_cell(
			expansions[2] + Vector2i(-2, -2), 3, Vector2i(12, 17)
		)

	start_round()

func start_round():
	for button in expansion_points:
		button.hide()

	if tower_edited != null:
		toggle_menu(tower_edited)
	
	var weights = []
	for enemy in enemies:
		var inst = enemy.instantiate()
		weights.append(1.0 / inst.worth)

	while _current_wave < (MAX_WAVE  * wave) / 100.0:
		if not get_tree().paused:
			# the stronger the enemy, the less likely to spawn (10x less likely)
			var enemy = enemies[
				_rng.rand_weighted(PackedFloat32Array(weights))
			]
			enemy = enemy.instantiate()
			enemy.path = paths.pick_random()
			enemy.process_mode = Node.PROCESS_MODE_PAUSABLE
			enemy.spawn(wave)

			add_child(enemy)
			_wave_enemies.append(enemy)
			enemy.connect("goal_reached", _enemy_event)
			enemy.connect("death", _enemy_event)

			_current_wave += enemy.worth

		await get_tree().create_timer(2).timeout

func finish_round():

	for button in expansion_points:
		button.show()

	for enemy in _wave_enemies:
		enemy.queue_free()

	if wave == WIN_AFTER:
		get_tree().change_scene_to_file("res://scenes/misc/win_screen.tscn")

	wave += 1
	_current_wave = 0
	_wave_enemies = []

	update_wave_label()

func can_buy(cost: int) -> bool:
	return _money >= cost

func update_money(amount: int) -> void:
	_money += amount
	hud.money_label.text = "Money: {}".format([_money], "{}")

func update_wave_label():
	hud.wave_label.text = "Wave: {}".format([wave], "{}")

func update_lives(decrement: int) -> void:
	_lives -= decrement
	hud.lives_label.text = "Lives: {}".format([_lives], "{}")

func toggle_menu(ref: Variant):
	if selected_tower != -1:
		for button in hud.tower_buttons.get_children():
			button.button_pressed = false
		selected_tower = -1

	if tower_edited != null and tower_edited.menu_transition:
		return

	if tower_edited == null:
		tower_edited = ref
		ref.show_menu()

	else:
		tower_edited.hide_menu()

		if tower_edited != ref:
			ref.show_menu()
			await tower_edited.menu_toggle
			tower_edited = ref
		else:
			await tower_edited.menu_toggle
			tower_edited = null

func update_tower_selection(index: int) -> void:
	if tower_edited != null:
		toggle_menu(tower_edited)

	if index == -1:
		selected_tower = -1
		if _tower_preview != null:
			_tower_preview.queue_free()
			_tower_preview = null
		return

	if selected_tower != -1:
		_tower_preview.queue_free()
		_tower_preview = null

	selected_tower = index

func is_valid_click(tower: Variant) -> bool:
	var pos = tile_cartesian_to_isometric(get_global_mouse_position())

	if coords_to_towers.has(pos):
		return coords_to_towers[pos] == tower

	return false


func get_neighbors(ref: Variant):
	var pos = towers_to_coords[ref]
	var neighbors = []

	for direction in cardinal_directions:
		var new_pos = pos + direction

		var tower = coords_to_towers.get(new_pos, null)
		if tower != null and tower.target == ref.target and tower.pos_or_neg == true:
			neighbors.append(tower)

	return neighbors

func _enemy_event(ref: Variant):
	if ref.dead:
		update_money(ref.worth)

	if ref.goal:
		update_lives(1)

		if _lives == 0:
			get_tree().change_scene_to_file("res://scenes/misc/lose_screen.tscn")

	if _wave_enemies.all(func(e): return e.dead or e.goal):
		finish_round()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var pos = tile_cartesian_to_isometric(get_global_mouse_position())
		if event.button_index == MOUSE_BUTTON_LEFT and selected_tower != -1:
			if not coords_to_towers.has(pos) \
			   	and tile_map.get_cell_atlas_coords(
					pos + Vector2i(-1, 0)
			   	) in tile_map.grass_tiles \
			   	and can_buy(
					_tower_preview.cost
			   	):

				var cartesian_pos = tile_isometric_to_cartesian(pos)

				var tower = towers[selected_tower].instantiate()
				tower.position = cartesian_pos
				coords_to_towers[pos] = tower
				towers_to_coords[tower] = pos

				update_money(-tower.cost)
				add_child(tower)
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			hud.hide()

func _process(_delta: float) -> void:
	var pos = tile_cartesian_to_isometric(get_global_mouse_position())
	if _tower_preview != null and selected_tower == -1:
		_tower_preview.queue_free()
		_tower_preview = null

	elif _tower_preview == null and selected_tower != -1:
		if not coords_to_towers.has(pos) \
			and tile_map.get_cell_atlas_coords(
				pos + Vector2i(-1, 0)
			) in tile_map.grass_tiles:

			_tower_preview = towers[selected_tower].instantiate()

			_tower_preview.position = tile_isometric_to_cartesian(pos)
			_tower_preview.target = -1
			_tower_preview.modulate = Color(1, 1, 1, 0.5)

			add_child(_tower_preview)

	elif selected_tower != -1:
		if not coords_to_towers.has(pos):
			if tile_map.get_cell_atlas_coords(
				pos + Vector2i(-1, 0)
			) in tile_map.grass_tiles and can_buy(
				_tower_preview.cost
			):
				_tower_preview.modulate = Color(1, 1, 1, 0.5)
			elif tile_map.get_cell_atlas_coords(
				pos + Vector2i(-1, 0)
			) == Vector2i(-1, -1):
				_tower_preview.modulate = Color(1, 1, 1, 0)
			else:
				_tower_preview.modulate = Color(1, 0.1, 0.1, 0.6)

			_tower_preview.position = tile_isometric_to_cartesian(pos)
