extends Node3D

@export var character_scene: PackedScene = null
@onready var animP = $Ladders/AnimationPlayer
@onready var carPlay = $"../Car82/Car8/AnimationPlayer"
@onready var chase = $AudioStreamPlayer
@onready var bgNoise = $"../../Environment/AudioStreamPlayer"

var ladder_has_fallen = false
var notAgain = false

func _ready():
	# Connect to animation finished signal
	animP.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "Fall":
		ladder_has_fallen = true

func _on_area_3d_2_body_entered(body):
	if ladder_has_fallen and not notAgain:
		print("Successfully has fallen")
		notAgain = true
		_last_stretch()
	else:
		print("No.")
		spawn_character(Vector3(6.8, 0.1, -23))

##Killer
func spawn_character(spawn_position: Vector3):
	# create instance
	var character = character_scene.instantiate()
	
	# Set position
	character.global_position = spawn_position
	
	# Add to scene tree
	add_child(character)
	
	return character
func _last_stretch():
	carPlay.play("blockEntrance")
	await get_tree().create_timer(5.0).timeout
	bgNoise.stop()
	chase.play()
	spawn_character(Vector3(0, 0, 7))
