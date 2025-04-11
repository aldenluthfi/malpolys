extends Node2D

@onready var camera = $camera
@export var next: PackedScene

var mouse_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position_smoothing_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	camera.position.x += 2
	camera.position.y += 1

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(next)


func _on_start_button_down() -> void:
	$gui/vbox/start/label.position.y = 24


func _on_start_mouse_exited() -> void:
	$gui/vbox/start/label.position.y = 16


func _on_start_mouse_entered() -> void:
	if mouse_pressed and $gui/vbox/start.button_pressed:
			$gui/vbox/start/label.position.y = 24
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_pressed = true
		else:
			mouse_pressed = false
