extends MeshInstance3D
@onready var scream = $AudioStreamPlayer3D
@onready var mainAudioPlace = $"../../Environment/AudioStreamPlayer"
@onready var head : MeshInstance3D = self
#CandyTruck
@onready var carAudio = $"../Car8/AudioStreamPlayer3D"
@onready var animp = $"../Car8/AnimationPlayer"
@onready var task_area = $taskArea
@onready var carryHead = $"../../CanvasLayer/carryHead"

@onready var tBar: ProgressBar = $"../../CanvasLayer/taskBar"
@onready var interactPrompt = $"../../../CanvasLayer/interactLabel"
@onready var localTimer : Node = $"../../TimerNode"
@onready var noSound =$"../../CanvasLayer/taskList/noSound"
@onready var colShape = $taskArea/CollisionShape3D

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

var musicLvl2 := preload("res://audio/bgm/Desolate_Underworld2.wav")
var hasPlayed = false


func _on_area_3d_body_entered(body):
	if hasPlayed == false:
		scream.play()
		mainAudioPlace.stream = musicLvl2
		mainAudioPlace.play()
		hasPlayed = true
		
		#CandyTruck
		carAudio.play()
		animp.play("driveScare")
		
		var task_ui = get_tree().get_first_node_in_group("task_ui")
		if task_ui:
			task_ui.add_task("Pick up the head.")
		else:
			push_warning("TASKUI not found.")
	else:
		pass

func interact():
	if task_name != "Clock in at the computer to start your shift." and task_ui and not task_ui.is_clocked_in():
		print("Need to clock in first!")
		noSound.play()
		return
		
		
	if is_doing_task or task_done:
		return  # Prevent re-triggering
	_doingTask()

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
	is_doing_task = false
	colShape.disabled = true
	task_done = true
	head.visible = false
	carryHead.visible = true
	nightCheck.hasHead = true
	
	if task_ui:
		task_ui.mark_task_complete("Pick up the head.")
		task_ui.add_task("Dispose of the head.")
		
	
	print(task_name + "✅ task complete! Took %.2f seconds." % task_duration)
	
	#resume player
	if player and player.has_method("resume"):
		player.resume()
	elif player:
		player.is_suspended = false



func _on_animation_player_animation_finished(driveScare):
	carAudio.stop()
