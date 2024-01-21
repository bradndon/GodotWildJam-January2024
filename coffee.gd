extends Control

var status = 1
var coffee = 1
var healthWidth
var can_refill = false
# Called when the node enters the scene tree for the first time.
func _ready():
	can_refill = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_accept") and can_refill:
		coffee = minf(coffee + .002, 1)
		status -= .0005
	elif Input.is_action_pressed("ui_accept") and coffee > 0 and status <= 1:
		coffee -= .002
		status = minf(status + .002, 1)
	else:
		status -= .0005

	$ColorRect.material.set_shader_parameter("inner_radius", status)
	$ProgressBar.value = coffee * 100


func _on_area_2d_body_entered(body):
	can_refill = true


func _on_area_2d_body_exited(body):
	can_refill = false # Replace with function body.
