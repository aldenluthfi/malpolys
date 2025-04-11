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
