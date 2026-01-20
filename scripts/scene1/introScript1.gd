extends Node3D

@onready var video_stream_subtitles = $Subtitles/Night1/VideoStreamSubtitles
@onready var video_stream_player = $Television/SubViewport/VideoStreamPlayer
var video1 := preload("res://videos/night1.ogv")
var video2 := preload("res://videos/night2.ogv")
var video3 := preload("res://videos/night3(1).ogv")
var video4 := preload("res://videos/night4(1).ogv")
var sub1 := preload("res://videos/subtitles/night1.srt")
var sub2 := preload("res://videos/subtitles/night2.srt")
var sub3 := preload("res://videos/subtitles/night3.srt")
var sub4 := preload("res://videos/subtitles/night4.srt")
@onready var camera_3d : TVCamera = $Camera3D
@onready var skip = $skipButton
@onready var skip_button = $skipButton/skipButton

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print("called")
	
	# Add safety check for nightCheck
	if nightCheck:
		if not nightCheck.night_changed.is_connected(update_video):
			nightCheck.night_changed.connect(update_video)
		# Defer the update to ensure all nodes are ready
		call_deferred("update_video")
	else:
		push_error("nightCheck autoload not found!")

func update_video():
	# Safety checks before accessing nodes
	if not is_instance_valid(video_stream_player):
		push_error("video_stream_player not found!")
		return
	
	if not is_instance_valid(video_stream_subtitles):
		push_error("video_stream_subtitles not found!")
		return
	
	print("subs node:", video_stream_subtitles)
	print("Current night:", nightCheck.night)
	
	if camera_3d:
		camera_3d.play_camera_animation()
	
	match nightCheck.night:
		0:
			print("hi its night 1")
			video_stream_player.stream = video1
			video_stream_subtitles.subtitles = sub1
			video_stream_player.play()
		1:
			print("hi its night 2")
			video_stream_player.stream = video2
			video_stream_subtitles.subtitles = sub2
			video_stream_player.play()
		2:
			print("hi its night 3")
			video_stream_player.stream = video3
			video_stream_subtitles.subtitles = sub3
			video_stream_player.play()
		3:
			print("hi its night 4")
			video_stream_player.stream = video4
			video_stream_subtitles.subtitles = sub4
			video_stream_player.play()
		4: # game ending 1 or 2
			pass
		_:
			push_error("Unknown night value: ", nightCheck.night)

func _exit_tree():
	if nightCheck and nightCheck.night_changed.is_connected(update_video):
		nightCheck.night_changed.disconnect(update_video)
