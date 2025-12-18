extends Control

@onready var container: VBoxContainer = $VBoxContainer
@onready var doneLabel: Label = $"../doneLabel"
@onready var doneSound = $doneSound
@onready var monitorSound = $monitorSound
@onready var localTimer : Node = $"../../TimerNode"
@export var clockTask : CheckBox = null

var tasks: Array[CheckBox] = []
var total_tasks := 1
var completed_tasks := 0

#track if the player has clocked in
var staged_tasks: Array[Dictionary] = [] # tasks to show after clock-in
var has_clocked_in: bool = false


func _ready():
	print("TaskUI ready!")
	add_to_group("task_ui")  # lets 3D scripts find this UI easily
	
	if clockTask:
		tasks.append(clockTask)
		clockTask.toggled.connect(_on_task_toggled.bind(clockTask))
		print("Linked clock-in task:", clockTask.text)
	else:
		push_warning("⚠️ No clockTask assigned in Inspector!")
	#after that is done, add these:
	match nightCheck.night:
		0:
			staged_tasks.append({"name": "Restock the Cooler", "is_special": false})
			staged_tasks.append({"name": "Put the boxes on the shelf", "is_special": false})
		1:
			staged_tasks.append({"name": "Restock the food on the empty shelf.", "is_special": false})

func add_task(name: String, is_special := false):
	var task = CheckBox.new()
	task.text = name
	task.name = name
	container.add_child(task)
	tasks.append(task)
	total_tasks += 1

	if is_special:
		task.set_meta("special", true)

	task.toggled.connect(_on_task_toggled.bind(task))
	print("Added task:", name)


func _on_task_toggled(button_pressed: bool, task: CheckBox):
	if button_pressed:
		completed_tasks += 1

		if task == clockTask and not has_clocked_in:
			_do_clock_in()

		if task.get_meta("special", false):
			_on_special_task_completed(task)

		if completed_tasks >= total_tasks:
			_on_all_tasks_complete()


func _on_special_task_completed(task: CheckBox):
	add_task("Reset backup systems")
	add_task("Reboot cameras")
	print("Special task completed! Added extra tasks.")
	
	
	
func _do_clock_in():
	if has_clocked_in:
		return
	has_clocked_in = true
	print("player locked in bru")

	#unlock staged tasks
	if staged_tasks.size()>0:
		_unlock_staged_tasks()
	
	#start globTimer
	if localTimer:
		print("Timer found:", localTimer)
		if localTimer.has_method("start_timer"):
			print("Starting timer…")
			localTimer.start_timer()
	else:
		print("❌ No TimerNode found!")
		#fading in
	var timeLabel = $"../TimeLabel"
	if timeLabel:
		_fade_in_time_label(timeLabel, 2.5)
		
	

func _unlock_staged_tasks():
	for t in staged_tasks:
		add_task(t["name"], t["is_special"])
	staged_tasks.clear()
	print("🟢 Staged tasks unlocked!")
	
func _on_all_tasks_complete():
	doneLabel.visible = true
	doneSound.play()
	print("🎉 All tasks complete!")


func mark_task_complete(task_name: String):
	for task in tasks:
		if task.text == task_name:
			if not task.button_pressed:
				task.set_pressed(true)
				task.call_deferred("set_disabled", true)
			if task == clockTask and not has_clocked_in:
				_do_clock_in()
			break
#called buddy GPT for this one:
func _fade_in_time_label(lbl: Node, duration: float = 2.5):
	# Ensure its modulate alpha starts at 0
	if lbl.has_method("set_modulate"):
		var m = lbl.modulate
		m.a = 0.0
		lbl.modulate = m
	# create a tween to animate modulate alpha to 1.0
	var tw = get_tree().create_tween()
	tw.tween_property(lbl, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func is_clocked_in() -> bool:
	return has_clocked_in
