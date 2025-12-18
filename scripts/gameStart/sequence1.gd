extends Camera3D
class_name TVCamera
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	# Connect the "animation_finished" signal
	anim.animation_finished.connect(_on_animation_finished)
	play_camera_animation()
	
func play_camera_animation():
	# Play the first animation
	anim.play("start")


# Called when any animation finishes
func _on_animation_finished(name: String):
	if name == "start":
		# Start the next animation and loop it
		anim.play("bob")
		anim.get_animation("bob").loop = true
