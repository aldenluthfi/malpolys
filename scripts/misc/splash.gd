extends Control

@export var load_scene: PackedScene
@export var in_time = 0.5
@export var fade_in_time = 1.0
@export var pause_time = 2.0
@export var fade_out_time = 1.0
@export var out_time = 0.5

@onready var splash_image = $centering/splash_image


func fade():
	splash_image.modulate.a = 0.0
	var tween = self.create_tween()
	
	tween.tween_interval(in_time)
	tween.tween_property(splash_image, "modulate:a", 1.0, fade_in_time)
	tween.tween_interval(pause_time)
	tween.tween_property(splash_image, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	
	await tween.finished
	
	get_tree().change_scene_to_packed(load_scene)
	
func _ready() -> void:
	fade()
