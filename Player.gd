extends CharacterBody2D


const SPEED = 240.0
const JUMP_VELOCITY = -400.0
var job
var timer
signal start_job(job)

func _on_score(value):
	print(value)

func _physics_process(delta):
	if get_parent().state != '':
		return
	if Input.is_action_just_pressed("ui_accept") and job != null:
		#var job_scene = load(job).instantiate()
		#job_scene.timer = timer
		emit_signal("start_job", job)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var motion = Vector2()
	var xdirection = Input.get_axis("ui_left", "ui_right")
	if xdirection:
		motion.x = xdirection
	else:
		motion.x = move_toward(velocity.x, 0, SPEED)
		
	var ydirection = Input.get_axis("ui_up", "ui_down")
	if ydirection:
		motion.y = ydirection
		motion.y /= 2
	else:
		motion.y = move_toward(velocity.y, 0, SPEED)
	velocity = motion.normalized() * SPEED

	move_and_slide()

func _on_job_enter(area):
	if area.get_parent().name == 'Chef':
		job = $"../CanvasLayer/VBoxContainer/Flames"
	elif area.get_parent().name == 'Sigil':
		job = $"../CanvasLayer/VBoxContainer/Sigil"


func _on_job_exit(area):
	if area.get_parent().name == 'Chef':
		job = null
		timer = null
	elif area.get_parent().name == 'Sigil':
		job = null
		timer = null
