extends Line2D

var drawing = false
var prev_image
var image =  Image.load_from_file("res://symbol2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		drawing = true
		clear_points()
	elif Input.is_action_just_released("ui_accept"):
		drawing = false
	
	if drawing:
		add_point(get_global_mouse_position())
		
#	var image = get_viewport().get_t/exture().get_image()
#	if prev_image:
	print(get_viewport().get_texture().get_image().compute_image_metrics(image, false))
#	prev_image = image
