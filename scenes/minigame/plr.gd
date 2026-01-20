extends CharacterBody2D
@onready var anim2 = $AnimatedSprite2D

var speed = 75  # speed in pixels/sec

func _ready():
	get_tree().paused = false
	if nightCheck.night == 2:
		speed = 125
	else:
		speed = speed
func _physics_process(delta):
	anim2.play("default")
	var direction = Input.get_vector("left", "right", "forward", "back")
	velocity = direction * speed

	move_and_slide()
