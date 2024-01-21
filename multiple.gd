extends Node2D
var score = 0
var total_score = 0
var state = ""
var current_job
@export var should_pick_job = false
@export var jobs: Array[Node2D] = []
var rent = 150
var payments = 0
var in_freeplay = false
var play_time = 0

var character
var characters = [
	preload('res://gandalf.png'),
	preload('res://hermione.jpg'),
	preload('res://alpheba.jpg'),
	preload('res://caleb.png')
]

func _restart():
	print('restart')
	GameManager.current_jobs = []
	get_tree().reload_current_scene()
	
func _continue():
	in_freeplay = true
	change_state('work')
# Called when the node enters the scene tree for the first time.
func change_state(new_state):
	print(new_state)
	if state == 'work':
		if should_pick_job:
			$CanvasLayer/VBoxContainer/Jobs.process_mode = Node.PROCESS_MODE_DISABLED
			$CanvasLayer/VBoxContainer/Jobs.visible = false
		else:
			current_job.visible = false

	elif state == 'choose_job':
		$CanvasLayer/VBoxContainer/JobChooser.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/JobChooser.visible = false
		if jobs.size() == 1:
			$MainTimer.start(30)
			$RentTimer.start(120)
	elif state == 'upgrade':
		$CanvasLayer/VBoxContainer/Upgrade.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/Upgrade.visible = false
	elif state == 'choose_character':
		$CanvasLayer/VBoxContainer/CharacterSelect.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/CharacterSelect.visible = false
		$CanvasLayer/VBoxContainer/Panel/TextureRect.texture = characters[character]
	elif state == 'menu':
		$CanvasLayer/VBoxContainer/Menu.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/Menu.visible = false
	elif state == 'how_to_sigil':
		$CanvasLayer/VBoxContainer/HowToSigil.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/HowToSigil.visible = false
	elif state == 'how_to_flames':
		$CanvasLayer/VBoxContainer/HowToFlames.process_mode = Node.PROCESS_MODE_DISABLED
		$CanvasLayer/VBoxContainer/HowToFlames.visible = false
	elif state == 'opening':
		$CanvasLayer/VBoxContainer/Opening.visible = false
		$CanvasLayer/VBoxContainer/Panel.visible = true
		$MainTimer.start(30)
		$RentTimer.start(120)
	elif state == 'gameover':
		$CanvasLayer/VBoxContainer/gameover.queue_free()
	elif state == 'win':
		$CanvasLayer/VBoxContainer/gameover.queue_free()
	state = new_state
	if state == 'work':
		for job in jobs:
			if job.job_name not in GameManager.seen_how_tos:
				change_state('how_to_' + job.job_name)
				GameManager.seen_how_tos.append(job.job_name)
				return
		if should_pick_job:
			$CanvasLayer/VBoxContainer/Panel.visible = true
			$CanvasLayer/VBoxContainer/Jobs.process_mode = Node.PROCESS_MODE_INHERIT
			$CanvasLayer/VBoxContainer/Jobs.visible = true
			$CanvasLayer/VBoxContainer/Jobs.jobs = jobs
			$CanvasLayer/VBoxContainer/Jobs.add_jobs()
			$MainTimer.paused = false
			$RentTimer.paused = false
		else:
			current_job.visible = true
		
	elif state == 'choose_job':
		$CanvasLayer/VBoxContainer/JobChooser.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/JobChooser.visible = true
	elif state == 'gameover':
		$MainTimer.stop()
		$RentTimer.stop()
		$CanvasLayer/VBoxContainer/Panel.visible = false
		var gameover = preload('res://gameover.tscn').instantiate()
		gameover.score = total_score
		gameover.payments = payments
		gameover.play_time = play_time
		$CanvasLayer/VBoxContainer.add_child(gameover)
		$CanvasLayer/VBoxContainer/gameover/Panel/Button.connect("pressed", _restart)
	elif state == 'win':
		$MainTimer.paused = true
		$RentTimer.stop()
		$CanvasLayer/VBoxContainer/Panel.visible = false
		var gameover = preload('res://winner.tscn').instantiate()
		gameover.score = total_score
		gameover.payments = payments
		gameover.play_time = play_time
		$CanvasLayer/VBoxContainer.add_child(gameover)
		$CanvasLayer/VBoxContainer/gameover/Panel/Button.connect("pressed", _restart)
		$CanvasLayer/VBoxContainer/gameover/Panel/Button2.connect("pressed", _continue)
		
	elif state == 'choose_character':
		$CanvasLayer/VBoxContainer/CharacterSelect.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/CharacterSelect.visible = true
		$CanvasLayer/VBoxContainer/Panel.visible = false
	elif state == 'menu':
		$CanvasLayer/VBoxContainer/Menu.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/Menu.visible = true
		$CanvasLayer/VBoxContainer/Panel.visible = false
	elif state == 'how_to_sigil':
		$CanvasLayer/VBoxContainer/HowToSigil.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/HowToSigil.visible = true
		$CanvasLayer/VBoxContainer/Panel.visible = false
	elif state == 'how_to_flames':
		$CanvasLayer/VBoxContainer/HowToFlames.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/HowToFlames.visible = true
		$CanvasLayer/VBoxContainer/Panel.visible = false
	elif state == 'upgrade':
		$CanvasLayer/VBoxContainer/Upgrade.process_mode = Node.PROCESS_MODE_INHERIT
		$CanvasLayer/VBoxContainer/Upgrade.visible = true
		$MainTimer.paused = true
		$RentTimer.paused = true
		if jobs.size() == 4:
			$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/choose2.visible = false
			$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/HBoxContainer2.visible = false
	elif state == 'opening':
		$CanvasLayer/VBoxContainer/Opening.visible = true

func _ready():
	#pass
	if should_pick_job:
		change_state('menu')
		#change_state('choose_job')
	
func pick_job(job, start_work=true):
	jobs.append(load(job).instantiate())
	if start_work:
		change_state('work')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/VBoxContainer/Panel/Label.text = "$" + str(score)
	$CanvasLayer/VBoxContainer/Panel/rent.text = "-$" + str(rent)
	var base = 0
	for j in GameManager.current_jobs:
		if j.lives <= 0:
			continue
		base += j.base

	var min = ceili($MainTimer.time_left) / 60
	var sec = ceili($MainTimer.time_left) % 60
	$CanvasLayer/VBoxContainer/Panel/time.text = " %02d:%02d" % [min, sec]
	var min2 = ceili($RentTimer.time_left) / 60
	var sec2 = ceili($RentTimer.time_left) % 60
	$CanvasLayer/VBoxContainer/Panel/renttime.text = " %02d:%02d" % [min2, sec2]
	$CanvasLayer/VBoxContainer/Panel/base.text = "+$" + str(base)
	if state == 'work':
		play_time += delta
	if state == 'work' and Input.is_action_just_pressed("ui_cancel"):
		change_state('')
		
	if state == 'work' and jobs.size() > 0 and GameManager.current_jobs.all(check_fired):
		change_state('gameover')

func check_fired(job):
	return job.lives <= 0

func _on_score(value):
	score += value
	total_score += value
	var score_scene = preload('res://score_up.tscn').instantiate()
	score_scene.get_child(0).text = "$" + str(value)
	score_scene.position = Vector2(randf_range(1160,1220), 69)
	$CanvasLayer/VBoxContainer/Panel/Label.add_child(score_scene)
	if total_score > 2500 and not in_freeplay:
		change_state('win')


func _on_timer_timeout():
	for j in GameManager.current_jobs:
		if j.lives <= 0:
			continue
		_on_score(j.base)
	$MainTimer.start(30)
	#if jobs.size() < 4:
		#change_state('choose_job')
	#else:
		#change_state('work')


func _on_start_job(job):
	current_job = job
	#print(job)
	#jobs = [job]
	#print(jobs)
	change_state('work')


func _on_character_select_choose_character(choice):
	character = choice
	GameManager.character = choice
	if choice == 0:
		pick_job('res://sigil.tscn', false)
	elif choice == 3:
		pick_job('res://flames.tscn', false)
	change_state('opening')



var upgrade_info
var up_job_index
func _on_jobs_level_up(job_index):
	up_job_index = job_index
	upgrade_info = GameManager.current_jobs[job_index]
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/Label.text = upgrade_info.name + ' Promotion!'
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/BasePay.text = "Base Pay: $" + str(upgrade_info.base + upgrade_info.baseup[(upgrade_info.level - 1) % upgrade_info.baseup.size()]) + " (+$" + str(upgrade_info.baseup[(upgrade_info.level - 1) % upgrade_info.baseup.size()]) + ")"

	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/HBoxContainer.visible = true
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/choose2.text = "Or pick up another job"
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/choose.visible = false
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/HBoxContainer/Upgrade1.text = upgrade_info.up1[upgrade_info.up1_val % upgrade_info.up1.size()]
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/HBoxContainer/Upgrade2.text = upgrade_info.up2[upgrade_info.up2_val % upgrade_info.up2.size()]
	$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/Panel3.visible = true
	if jobs.size() == 1:
		$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/choose2.text = "I'll never make rent at this rate,\nI can probably manage another job..."
		$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/choose.visible = false
		$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/Panel3.visible = false
		$CanvasLayer/VBoxContainer/Upgrade/VBoxContainer/HBoxContainer.visible = false

		
	change_state('upgrade')



func _on_upgrade_upgrade(choice):
	GameManager.current_jobs[up_job_index].base += upgrade_info.baseup[(upgrade_info.level - 1) % upgrade_info.baseup.size()]
	GameManager.current_jobs[up_job_index].level += 1
	if choice == 0:
		jobs[up_job_index].apply_upgrade(GameManager.current_jobs[up_job_index].up1[GameManager.current_jobs[up_job_index].up1_val % GameManager.current_jobs[up_job_index].up1.size()])
		GameManager.current_jobs[up_job_index].up1_val += 1
		change_state('work')
	elif choice == 1:
		jobs[up_job_index].apply_upgrade(GameManager.current_jobs[up_job_index].up2[GameManager.current_jobs[up_job_index].up2_val % GameManager.current_jobs[up_job_index].up2.size()])
		GameManager.current_jobs[up_job_index].up2_val += 1
		change_state('work')
	elif choice == 2:
		pick_job("res://sigil.tscn")
	elif choice == 3:
		pick_job("res://flames.tscn")



func _on_rent_timer_timeout():
	if score < rent:
		change_state('gameover')
	else:
		score -= rent
		payments += 1
		rent += 75
		$RentTimer.start(120 - payments * 5)


func _on_button_pressed():
	change_state('work')


func _on_menu_pressed():
	change_state('choose_character') # Replace with function body.


func _on_how_to_pressed():
	change_state('work')
