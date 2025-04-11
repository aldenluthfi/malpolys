extends Node2D

const MAX_INT = 2147483647
const MAX_WAVE = 1000
const WIN_AFTER = 50

@onready var add: PackedScene = preload("res://scenes/towers/add.tscn")
@onready var mul: PackedScene = preload("res://scenes/towers/mul.tscn")
@onready var mod: PackedScene = preload("res://scenes/towers/mod.tscn")

@onready var lins: PackedScene = preload("res://scenes/enemies/lins.tscn")
@onready var quads: PackedScene = preload("res://scenes/enemies/quads.tscn")
@onready var cubes: PackedScene = preload("res://scenes/enemies/cubes.tscn")
@onready var exes: PackedScene = preload("res://scenes/enemies/exes.tscn")

@onready var enemies: Array[PackedScene] = [cubes, quads, lins, exes]
@onready var towers: Array[PackedScene] = [add, mul, mod]

var selected_tower: int = -1

func tile_isometric_to_cartesian(coords: Vector2i) -> Vector2i:
	return Vector2i(
		coords.x * 32 - coords.y * 32,
		coords.x * 16 + coords.y * 16
	)

func tile_cartesian_to_isometric(coords: Vector2) -> Vector2i:
	var _x = coords.x / 32
	var _y = coords.y / 16

	var x = (_x + _y) / 2
	var y = (_y - x)
	return Vector2i(round(x), round(y))
