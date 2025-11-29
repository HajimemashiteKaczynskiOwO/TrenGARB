# TimeLabel.gd (attach to Label)
extends Label

@onready var timer_node: Node = $"../../TimerNode"

func _process(delta):
	if timer_node and timer_node.has_method("get_game_time"):
		text = timer_node.get_game_time()
