extends MeshInstance3D

@onready var tBar: ProgressBar = $"../../../CanvasLayer/taskBar"
@onready var interactArea: Area3D = $interactArea
@onready var interactPrompt = $"../../../CanvasLayer/interactLabel"  # Adjust path to your UI
@onready var localTimer : Node = $"../../../TimerNode"
@export var taskArea : CollisionShape3D = null
@onready var monitorSound = $"../../../CanvasLayer/taskList/monitorSound"
#  durations
var sTaskTime1: float = 5.0
var sTaskTime2: float = 5.5
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
	print("READY:", name)
	add_to_group("task_objects")  # Add to group so TaskUI can notify us
	task_ui = get_tree().get_first_node_in_group("task_ui")
	
	if task_name == "" and task_ui:
		task_name = _format_task_name(name)
		print("Auto-linked task: %s" % task_name)
	

func _format_task_name(n: String) -> String:
	var formatted := ""
	for i in range(n.length()):
		var c := n[i]
		# Insert a space before uppercase letters (except the first)
		if i > 0 and c >= "A" and c <= "Z" and n[i - 1] >= "a" and n[i - 1] <= "z":
			formatted += " "
		formatted += c
	return formatted.capitalize()

func interact():
	if task_name != "Clock in at the computer to start your shift." and task_ui and not task_ui.is_clocked_in():
		print("Need to clock in first!")
		_show_temporary_prompt("Clock in before doing any tasks!",2)
		return
		
		
	if is_doing_task or task_done:
		return  # Prevent re-triggering
	_doingTask()

func _doingTask() -> void:
	var player = get_tree().get_first_node_in_group("player")  # adjust path
	if player and player.has_method("suspend"):
		player.suspend()
		monitorSound.play()
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

	#complete
	if taskArea:
		taskArea.disabled = true
	tBar.value = 100
	tBar.visible = false
	is_doing_task = false
	task_done = true
	print(task_name + "✅ task complete! Took %.2f seconds." % task_duration)
	
	#resume player
	if player and player.has_method("resume"):
		player.resume()
	elif player:
		player.is_suspended = false

	# disable further interaction
	interactArea.monitoring = false
	interactArea.visible = false

	# tell ui
	if task_ui and task_name != "":
		print("Marking task complete in UI:", task_name)
		task_ui.mark_task_complete(task_name)


func _on_interact_area_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "CharacterBody3D":
		cancel_task = true
		player_near = false
		_hide_interact_prompt()

func _hide_interact_prompt():
	if interactPrompt:
		interactPrompt.visible = false

func _show_temporary_prompt(text: String, secs: float = 1.2):
	if interactPrompt:
		interactPrompt.text = text
		interactPrompt.visible = true
		# hide after secs
		var tw = get_tree().create_tween()
		tw.tween_callback(Callable(self, "_hide_interact_prompt")).set_delay(secs)
