extends MeshInstance3D
@onready var screen_mesh: MeshInstance3D = $Screen
@onready var viewport: SubViewport = $SubViewport
var video_3 = null
@onready var ladderFall = $"../../Scary/OutsideNode/Ladders/AnimationPlayer"
var task_ui: Node = null

func _ready():
	task_ui = get_tree().get_first_node_in_group("task_ui")
	# Try to find the video player
	if viewport.has_node("video3"):
		video_3 = viewport.get_node("video3")
	elif viewport.has_node("VideoStreamPlayer"):
		video_3 = viewport.get_node("VideoStreamPlayer")
	else:
		push_error("No video player found in SubViewport!")
		return
	
	var mat := screen_mesh.get_active_material(0)
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("screen_texture", viewport.get_texture())
	
	# Connect the finished signal
	if video_3 and not video_3.finished.is_connected(_on_video_finished):
		video_3.finished.connect(_on_video_finished)

func _process(delta):
	if not video_3:
		return
		
	if nightCheck.timePass and not video_3.is_playing():
		video_3.play()

func _on_video_finished():
	nightCheck.timePass = false
	ladderFall.play("Fall")
	task_ui.mark_task_complete("Investigate the TV.")
	task_ui.add_task("Investigate the noise.")
	
