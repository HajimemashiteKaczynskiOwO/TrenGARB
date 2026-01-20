extends Node
@onready var timer_node = $TimerNode

signal night_changed(night)

var night = 0
var fin = 0
var timePass = false #if 1AM has passed.
var pleasedCustomer = 0
var completionist = false
var hasHead = false

func night_passed():
	night += 1
	emit_signal("night_changed", night)
	get_tree().paused = false


# also including customersPleased because why not
func pleased_customer():
	pleasedCustomer += 1
