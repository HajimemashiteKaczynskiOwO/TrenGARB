extends CSGSphere3D
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("spin")

func _process(delta):
	if anim.is_playing():
		pass
	else:
		anim.play("spin")
