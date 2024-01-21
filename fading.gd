extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("inner_radius", material.get_shader_parameter("inner_radius") - 0.001)
