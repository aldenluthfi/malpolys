extends Control

@onready var parent = get_parent()
@onready var upgrade_cost = get_node("%cost")
@onready var upgrade_blocker = get_node("%unupgradable")

func _on_upgrade_pressed() -> void:
	parent.upgrade()

# 0 = health, 1 = shield, 2 = speed
func _on_neg_health_pressed() -> void:
	parent.change_target(0, false)


func _on_pos_health_pressed() -> void:
	parent.change_target(0, true)


func _on_neg_shield_pressed() -> void:
	parent.change_target(1, false)


func _on_pos_shield_pressed() -> void:
	parent.change_target(1, true)


func _on_neg_speed_pressed() -> void:
	parent.change_target(2, false)


func _on_pos_speed_pressed() -> void:
	parent.change_target(2, true)
