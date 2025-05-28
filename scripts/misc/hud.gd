extends Control



@onready var parent = get_parent().get_parent()

@onready var money_label = get_node("%money")
@onready var lives_label = get_node("%lives")
@onready var wave_label = get_node("%wave")
@onready var add_button = get_node("%add")
@onready var mul_button = get_node("%mul")
@onready var tower_buttons = get_node("%towers/margin/horizontal")

func _on_tower_select(index: int) -> void:
	parent.update_tower_selection(index)


func _on_pause_play_toggled(toggled_on: bool) -> void:
	get_tree().paused = not get_tree().paused


func _on_ff_button_toggled(toggled_on: bool) -> void:
	if Engine.time_scale == 3:
		Engine.time_scale = 1
	else:
		Engine.time_scale = 3
