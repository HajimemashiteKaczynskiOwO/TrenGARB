extends MeshInstance3D
@onready var anim = $AnimationPlayer
@onready var interactPrompt = $"../../../CanvasLayer/interactLabel"
@onready var carryHead = $"../../../CanvasLayer/carryHead"
@onready var colshape = $headThrowBody/CollisionShape3D

@onready var tBar: ProgressBar = $"../../../CanvasLayer/taskBar"
@onready var localTimer : Node = $"../../TimerNode"
@onready var noSound = $"../../CanvasLayer/taskList/noSound"

@onready var dump : MeshInstance3D = $"../Dump"

#  durations
var sTaskTime1: float = 3.0
var sTaskTime2: float = 6.0
var lTaskTime1: float = 10.0
var lTaskTime2: float = 15.0

# type of this task ("short" or "long")
@export var task_type: String = "short"
@export var task_name: String = ""
var task_ui: Node = null

var is_doing_task: bool = false
var cancel_task: bool = false
var task_done: bool = false
var player_near: bool = false

func _ready():
	anim.play("Open")
var is_closed: bool = true


func interact():
	if nightCheck.hasHead:
		_doingTask()
	else:
		interactPrompt.text = "Investigate the storage room first."
		await get_tree().create_timer(3).timeout
		interactPrompt.text= ""

func _doingTask() -> void:
	var task_ui = get_tree().get_first_node_in_group("task_ui")
	var player = get_tree().get_first_node_in_group("player")  # adjust path
	if player and player.has_method("suspend"):
		player.suspend()
	elif player:
		player.is_suspended = true
		
	is_doing_task = true
	tBar.visible = true
	cancel_task = false
	tBar.value = 0

	# Pick the correct time range
	var task_duration: float = sTaskTime1
	if task_type == "long":
		task_duration = randf_range(lTaskTime1, lTaskTime2)
	else:
		task_duration = randf_range(sTaskTime1, sTaskTime2)

	var elapsed := 0.0

	while elapsed < task_duration:
		if cancel_task:
			print("❌ Task cancelled")
			tBar.visible = false
			is_doing_task = false
			if player and player.has_method("resume"):
				player.resume()
			elif player:
				player.is_suspended = false
			return
		
		var delta := get_process_delta_time()
		elapsed += delta
		tBar.value = clamp((elapsed / task_duration) * 100.0, 0, 100)
		await get_tree().process_frame
		
	tBar.value = 100
	tBar.visible = false
	carryHead.visible = false
	nightCheck.hasHead = true
	colshape.disabled = true
	
	if task_ui:
		task_ui.mark_task_complete("Dispose of the head.")

		
	
	print(task_name + "✅ task complete! Took %.2f seconds." % task_duration)
	
	#resume player
	if player and player.has_method("resume"):
		player.resume()
	elif player:
		player.is_suspended = false
