extends Node2D

signal menu_toggle()

@export var cost: int
@export var MAX_LEVEL: int

@onready var parent = get_parent()
@onready var modulator = $modulate
@onready var base = $base
@onready var menu = $tower_menu
@onready var area = $range
@onready var place_audio = $place
@onready var destroy_audio = $destroy

var target: int = 0
var pos_or_neg: bool = false

var level: int = 1
var modulates = {
	"neg_health": Color8(202, 38, 37),
	"pos_health": Color8(34, 197, 93),
	"neg_shield": Color8(249, 115, 21),
	"pos_shield": Color8(36, 99, 235),
	"neg_speed": Color8(235, 179, 5),
	"pos_speed": Color8(124, 58, 237),
	"default": Color8(255, 255, 255)
}

var menu_transition: bool

func f(_g):
	pass

func decode_mode():
	match [target, pos_or_neg]:
		[0, false]:
			return "neg_health"
		[0, true]:
			return "pos_health"
		[1, false]:
			return "neg_shield"
		[1, true]:
			return "pos_shield"
		[2, false]:
			return "neg_speed"
		[2, true]:
			return "pos_speed"
		_:
			return "default"

func upgrade():
	if not parent.can_buy(get_upgrade_cost()) or level == MAX_LEVEL:
		return

	parent.update_money(-get_upgrade_cost())

	level += 1

	base.play(str(level))
	modulator.play(str(level))

	cost += floor(cost * 0.8)
	if level < MAX_LEVEL:
		menu.upgrade_cost.text = str(get_upgrade_cost())
	else:
		menu.upgrade_cost.visible = false
		menu.upgrade_blocker.visible = true

func change_target(new_target: int, pos: bool) -> void:
	target = new_target
	pos_or_neg = pos

	modulator.modulate = modulates[decode_mode()]

func show_menu() -> void:
	menu_transition = true

	if is_equal_approx(menu.scale.x, 1):
		menu_toggle.emit()
		menu_transition = false
		return

	menu.scale = lerp(menu.scale, Vector2(1, 1), 0.25)
	await get_tree().create_timer(1 / 60.0).timeout
	show_menu()

func hide_menu() -> void:
	menu_transition = true

	if is_equal_approx(menu.scale.x, 0):
		menu_transition = false
		menu_toggle.emit()
		return

	menu.scale = lerp(menu.scale, Vector2(0, 0), 0.25)
	await get_tree().create_timer(1 / 60.0).timeout
	hide_menu()

func get_upgrade_cost():
	return floor(cost * 0.8)

func apply_effect(affected: Variant, callers: Array = []) -> void:
	callers.append(self)
	match target:
		0:
			affected.set_health_function(f.call(affected.f_health))

			for neighbor in parent.get_neighbors(self):
				if neighbor in callers:
					continue

				callers.append(neighbor)
				neighbor.apply_effect(affected, callers)

			affected.update_health(parent.wave)

		1:
			affected.set_shield_function(f.call(affected.f_shield))

			for neighbor in parent.get_neighbors(self):
				if neighbor in callers:
					continue

				callers.append(neighbor)
				neighbor.apply_effect(affected, callers)

			affected.update_shield(parent.wave)
		2:
			affected.set_speed_function(f.call(affected.f_speed))

			for neighbor in parent.get_neighbors(self):
				if neighbor in callers:
					continue

				callers.append(neighbor)
				neighbor.apply_effect(affected, callers)

			affected.update_speed(parent.wave)

func _ready() -> void:
	change_target(target, pos_or_neg)
	menu.scale = Vector2(0, 0)
	
	area.connect("area_entered", _on_range_entered)
	destroy_audio.connect("finished", _on_destroy_finished)
	
	if target != -1:
		place_audio.play()
		
	menu.upgrade_cost.text = str(get_upgrade_cost())

func _input(event: InputEvent) -> void:
	var pos = parent.tile_cartesian_to_isometric(get_global_mouse_position())
	if event is InputEventMouseButton and event.is_pressed() and parent.is_valid_click(self):
		if event.button_index == MOUSE_BUTTON_LEFT:
			parent.toggle_menu(self)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			destroy_audio.play()
			parent.coords_to_towers.erase(pos)
			parent.towers_to_coords.erase(self)
			
			hide()
			
			parent.update_money(cost)

func _on_range_entered(body: Area2D) -> void:
	var enemy = body.get_parent()

	if enemy is Enemy and not pos_or_neg:
		apply_effect(enemy)
		

func _on_destroy_finished() -> void:
	queue_free()
