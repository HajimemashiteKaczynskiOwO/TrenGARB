extends Node3D

@onready var video_stream_player = $Television/SubViewport/VideoStreamPlayer
var video1 := preload("res://videos/night1.ogv")
var video2 := preload("res://videos/night2.ogv")
var video3 := preload("res://videos/night3(1).ogv")
var video4 := preload("res://videos/night4(1).ogv")
@onready var camera_3d : TVCamera = $Camera3D
@onready var skip = $skipButton
@onready var skip_button = $skipButton/skipButton


func _ready():
	print("called")
	nightCheck.connect("night_changed", Callable(self, "update_video"))
	update_video()

func update_video():
	camera_3d.play_camera_animation()
	match nightCheck.night:
		0:
			print("hi its night 1")
			video_stream_player.stream = video1
			video_stream_player.play()
			skip.visible = true
		1:
			print("hi its night 2")
			
			video_stream_player.stream = video2
			video_stream_player.play()
			print("wplaw")
			skip.visible = true
		2:
			print("hi its night 3")
			
			video_stream_player.stream = video3 #change to 3
			video_stream_player.play()
			print("wplaw")
			skip.visible = true
		
		3:
			print("hi its night 4")
			
			video_stream_player.stream = video4 #change to 4
			video_stream_player.play()
			print("wplaw")
			skip.visible = false
		
		4: #game ending 1 or 2
			#iajfksajfkjsafan
			pass
