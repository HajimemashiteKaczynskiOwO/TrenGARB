extends Node3D
@export var sceneM: PackedScene
@onready var timer = $Timer
@export var show : Label = null
@onready var mk3 = $Marker3D
@onready var spEf = $"../MoserSpawner/SpawnEf"

var spawnposition = Vector3()
var canSpawn = false
var moser = 0
func _ready():
	canSpawn = true
	spawnposition = mk3.position

func _spawn():
	spEf.emitting = true
	var instance = sceneM.instantiate()
	instance.initialize(spawnposition)
	add_child(instance)
	show.text = "-> " + str(moser*3)
	timer.start()

func _on_timer_timeout():
	print(moser*3, " Enemies")
	moser+=1
	_spawn()
