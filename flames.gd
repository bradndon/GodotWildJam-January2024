extends Job

var to_cook = {}
var flames = 2
var cooking = false
var on_screen = 0
var job_name = 'flames'
var comission = 1
var cooktime = 0.5
var speed = 80.0
@onready var paths = [$Path2D1, $Path2D2, $Path2D3]
@onready var raw = preload("res://raw.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	base_pay = 15
	if timer == null:
		timer = $Timer
		timer.start(randf_range(1,1))
	timer.connect("timeout", _on_timer_timeout)

func apply_upgrade(upgrade):
	if upgrade == "Cook time +.5s\nComission +$1":
		cooktime += .5
		comission += 1
	elif upgrade == "Speed +10%\nComission +$1":
		speed += speed * .1
		comission += 1
	elif upgrade == "Speed -5%\nComission -$1":
		speed -= speed * .05
		comission -= 1
	elif upgrade == "Cook time -.25s\n Comission -$1":
		comission -= 1
		cooktime -=.25
	print(speed)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.current_jobs[job_index].lives <= 0:
		$Panel.visible = true
		timer.stop()
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		$Panel.visible = false
		
func _physics_process(delta):
	for b in to_cook.values():
		b.cook_a_bit(delta)
		

func _on_area_2d_body_entered(body: Node2D):
	to_cook[body.name] = body

func _on_exit_auto_cook(body):
	to_cook.erase(body.name)

func _on_area_2d_body_exited(uncooked):
	if uncooked:
		GameManager.current_jobs[job_index].lives -= 1
		on_screen -= 1

func _on_cooked():
	emit_signal("score", comission)
	on_screen -= 1
	var old_level = 1 + floori(job_score / 5)
	job_score += 1
	var level = 1 + floori(job_score / 5)
	if old_level != level:
		emit_signal('level_up', job_index)
	

func _on_timer_timeout():
	timer.start(randi_range(3,7))
	var new_raw = raw.instantiate()
	new_raw.get_child(0).cooktime = cooktime
	new_raw.get_child(0).speed = speed
	if GameManager.character == 3:
		new_raw.get_child(0).cooktime *= .8
	print(new_raw.get_child(0).cooktime)
	new_raw.get_child(0).connect("exit_screen", _on_area_2d_body_exited)
	new_raw.get_child(0).connect("cooked", _on_cooked)
	paths.pick_random().add_child(new_raw)
	on_screen += 1

func _on_icon_button_down():
	cooking = true



func _on_icon_button_up():
	cooking = false



func _on_icon_mouse_exited():
	cooking = false
