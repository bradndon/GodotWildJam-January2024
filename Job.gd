extends Node2D
class_name Job

@export var timer: Timer
@export var lives = 3
var job_score = 0
@export var base_pay = 10
var job_index

signal score(value)
signal level_up(job_index)

func _process(delta):
	print('process')
