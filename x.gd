extends Node2D

@export var job: Job
@export var strike_num = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if 3 - GameManager.current_jobs[job.job_index].lives >= strike_num:
		visible = true
	else:
		visible = false
