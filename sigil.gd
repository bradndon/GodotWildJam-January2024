extends Job

var options = ["b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8"]
var sigils = [
	preload('res://sigils/b1.png'), 
	preload('res://sigils/b2.png'),
	preload('res://sigils/b3.png'),
	preload('res://sigils/b4.png'),
	preload('res://sigils/b5.png'),
	preload('res://sigils/b6.png'),
	preload('res://sigils/b7.png'),
	preload('res://sigils/b8.png')
]
var pattern = []
var textures: Array[Texture2D] = []
var pressed = []
var job_name = 'sigil'
var comission = 4
var pattern_length = 4
var rune_count = 4
var timer_length = 20
var scroll: PackedScene = preload("res://scroll.tscn")
var scroll_scene: Node2D
func gen_pattern(reset_timer = true):
	for i in options:
		find_child(i).disabled = false
	for i in range(sigils.size() - rune_count):
		var next_option = randi_range(0, sigils.size() -1)
		while find_child(options[next_option]).disabled:
			next_option = randi_range(0, sigils.size() -1)
		find_child(options[next_option]).disabled = true
	pattern = []
	textures = []
	for i in range(min(pattern_length, 8)):
		var next_option = randi_range(0, sigils.size() -1)
		while find_child(options[next_option]).disabled:
			next_option = randi_range(0, sigils.size() -1)
		pattern.append(options[next_option])
		textures.append(sigils[next_option])
		
			
	if scroll_scene:
		scroll_scene.queue_free()
	var new_scroll = scroll.instantiate()
	new_scroll.runes = textures
	scroll_scene = new_scroll
	add_child(new_scroll)
	if reset_timer:
		timer.start(timer_length)

func apply_upgrade(upgrade):
	if upgrade == "Rune Options +1\nComission +$1":
		rune_count += 1
		comission += 1
	elif upgrade == "Transport Length +1\nComission +$1":
		pattern_length += 1
		comission += 1
	elif upgrade == "Time -2s\nComission +1$":
		timer_length -= 2
		comission += 1
	elif upgrade == "Time +1s\nComission -$1":
		timer_length += 1
		comission -= 1
	gen_pattern()

# Called when the node enters the scene tree for the first time.
func _ready():
		
	if GameManager.character == 0:
		pattern_length -= 1
	if timer == null:
		timer = $Timer
		timer.start(20)
	$ProgressBar.max_value = timer.wait_time
	timer.connect("timeout", _on_timer_timeout)
	gen_pattern(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.max_value = timer.wait_time
	$ProgressBar.value = timer.time_left
	if GameManager.current_jobs[job_index].lives <= 0:
		$Panel.visible = true
		timer.stop()
		process_mode = Node.PROCESS_MODE_DISABLED
	else:
		$Panel.visible = false

func play_pattern():
	for p in pattern:
		get_node(p).modulate = Color(0,0,0,0)
		await get_tree().create_timer(0.5).timeout
		get_node(p).modulate = Color(1,1,1,1)
		await get_tree().create_timer(0.5).timeout

func _on_pressed(btn: String):
	pressed.append(btn)
	get_node(btn).release_focus()

	get_node(btn).get_child(0).restart()
	get_node(btn).get_child(0).emitting = true
	get_node(btn).get_child(1).play()
	if pressed == pattern:
		emit_signal("score", comission)

		var old_level = 1 + floori(job_score / 5)
		job_score += 1
		var level = 1 + floori(job_score / 5)
		pressed = []
		if old_level != level:
			emit_signal('level_up', job_index)
		gen_pattern()

	
	for i in pressed.size():
		if pressed[i] != pattern[i]:
			pressed = []
			GameManager.current_jobs[job_index].lives -= 1
			gen_pattern(false)
		else:
			scroll_scene.get_node(str(i + 1)).modulate = Color(0,1,0,1)
			#get_node("Sprite" + str(i)).modulate = Color(0,1,0,1)


func _on_timer_timeout():
	pressed = []
	GameManager.current_jobs[job_index].lives -= 1
	gen_pattern()
