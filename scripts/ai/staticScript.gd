extends StaticBody3D

@onready var tBar: ProgressBar = $"../../../CanvasLayer/taskBar"
@onready var interactPrompt = $"../../../CanvasLayer/interactLabel"  # Adjust path to your UI
@onready var localTimer : Node = $"../../../TimerNode"
@onready var interactArea: CollisionShape3D = $CollisionShape3D
@onready var checkout = $".."

@onready var scanBody = $CollisionShape3D

var sTaskTime1: float = 1.0
var sTaskTime2: float = 3.5
var lTaskTime1: float = 3.5
var lTaskTime2: float = 6.5

# type of this task ("short" or "long")
@export var task_type: String = "long"
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
		
	if is_doing_task or task_done:
		return  # Prevent re-triggering
	_doingTask()

func _doingTask() -> void:
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
			print("❌ Scan cancelled")
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
	scanBody.disabled = true

	# tell ui
	if task_ui and task_name != "":
		print("Marking task complete in UI:", task_name)
		task_ui.mark_task_complete(task_name)

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
