extends CharacterBody3D
@onready var anim = $AnimationPlayer

@export var Player : CharacterBody3D = null


func _process(delta):
	print(Player.position)
