extends TextureButton

@export var select_index: int
@export var cost: int

@onready var cost_label = $cost
@onready var parent = get_parent()

signal tower_select(index)

func _ready() -> void:
	cost_label.text = "${}".format([str(cost)], "{}")

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		tower_select.emit(select_index)
	else:
		tower_select.emit(-1)
