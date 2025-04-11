extends "res://scripts/misc/globals.gd"

class_name Enemy

@export var worth: int

signal goal_reached(ref)
signal death(ref)

@onready var bars = $bars
@onready var health_bar = $bars/health
@onready var shield_bar = $bars/shield
@onready var speed_bar = $bars/speed

@onready var sprite = $sprite
@onready var audio = $player


var health: float
var shield: float
var speed: float

var path: Array

const MIN_SPEED = 50.0
const MAX_SPEED = MAX_INT

var _rng

var goal: bool = false
var dead: bool = false

func f(_x):
	pass

var f_health = f
var f_shield = f
var f_speed = func (x): return MIN_SPEED + min(max(f.call(x), 0), MAX_SPEED - MIN_SPEED)

func _ready() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.randomize()

	if not sprite.animation_finished.is_connected(_on_death):
		sprite.connect("animation_finished", _on_death)

func _process(delta: float) -> void:

	if path == []:
		hide()
		goal = true
		goal_reached.emit(self)
		return set_process(false)

	var cartesian_path = tile_isometric_to_cartesian(path[0] + Vector2i(1, 0))

	if position.x - cartesian_path.x == 0 and position.y - cartesian_path.y == 0:
		path = path.slice(1)


	position.x = move_toward(
		position.x,
		cartesian_path.x,
		delta * speed
	)

	position.y = move_toward(
		position.y,
		cartesian_path.y,
		delta * speed
	)

func update_health(wave):
	var old_health = health
	health = f_health.call(wave)

	var damage_taken = old_health - health

	if shield > 0:
		health += damage_taken * (0.5 * shield / shield_bar.max_value)

	health_bar.value = health

	if health <= 0 and not dead:
		set_process(false)
		bars.hide()
		sprite.play("death")
		audio.play()


func update_shield(wave):
	shield = f_shield.call(wave)
	shield_bar.value = shield

func update_speed(wave):
	speed = min(max(f_speed.call(wave), MIN_SPEED), MAX_SPEED)
	speed_bar.value = speed

func set_health_function(g: Callable):
	f_health = g

func set_shield_function(g: Callable):
	f_shield = g

func set_speed_function(g: Callable):
	f_speed = g

func _on_death():
	if sprite.animation == "death":
		dead = true
		death.emit(self)
		hide()

func spawn(wave):
	_ready()

	position = tile_isometric_to_cartesian(path[0] + Vector2i(1, 0))

	health = f_health.call(wave)
	shield = f_shield.call(wave)
	speed = f_speed.call(wave)

	health_bar.max_value = health
	health_bar.value = health

	shield_bar.max_value = shield
	shield_bar.value = shield

	speed_bar.max_value = speed
	speed_bar.value = speed
