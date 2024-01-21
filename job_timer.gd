extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Progress.max_value = wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Progress.max_value = wait_time
	$Progress.value = time_left
