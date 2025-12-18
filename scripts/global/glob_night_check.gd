extends Node

signal night_changed(night)

var night = 1
var pleasedCustomer = 0

func night_passed():
	night += 1
	emit_signal("night_changed", night)
	get_tree().paused = false


# also including customersPleased because why not
func pleased_customer():
	pleasedCustomer += 1
