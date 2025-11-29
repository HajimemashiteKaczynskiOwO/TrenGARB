extends Camera3D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	# Connect the "animation_finished" signal
	anim.animation_finished.connect(_on_animation_finished)
	
	# Play the first animation
	anim.play("start")

# Called when any animation finishes
func _on_animation_finished(name: String):
	if name == "start":
		# Start the next animation and loop it
		anim.play("bob")
		anim.get_animation("bob").loop = true
