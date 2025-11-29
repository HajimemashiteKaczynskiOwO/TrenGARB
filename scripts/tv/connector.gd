extends MeshInstance3D

@onready var screen_mesh: MeshInstance3D = $Screen
@onready var viewport: SubViewport = $SubViewport

func _ready():
	var mat := screen_mesh.get_active_material(0)
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("screen_texture", viewport.get_texture())
