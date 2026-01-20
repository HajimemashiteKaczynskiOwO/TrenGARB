extends Node3D

@onready var player = $CharacterBody3D

func _physics_process(delta):
	get_tree().call_group("enemy", "update_target_loc", player.global_transform.origin)
