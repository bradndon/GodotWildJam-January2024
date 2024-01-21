extends TextureProgressBar

@export var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = timer.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	max_value = timer.wait_time
	value = timer.time_left
