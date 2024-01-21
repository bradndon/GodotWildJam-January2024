extends VBoxContainer
var all_jobs = {
	'flames': preload('res://flames.tscn'),
	'sigil': preload('res://sigil.tscn')
}
var jobs = [
]
var _on_score = on_score
signal score(value)
signal level_up(job_index)

func add_jobs():
	print('jobs')
	var games = [
		$HBoxContainer/VBoxContainer/Game1/SubViewport,
		$HBoxContainer/VBoxContainer2/Game2/SubViewport,
		$HBoxContainer2/VBoxContainer/Game1/SubViewport,
		$HBoxContainer2/VBoxContainer2/Game2/SubViewport
	]
	$HBoxContainer2.visible = true
	$HSeparator.visible = true
	$HBoxContainer/VBoxContainer2.visible = true
	$HBoxContainer/VSeparator.visible = true
	$HBoxContainer/VBoxContainer/Game1Bot.visible = true
	$HBoxContainer/VBoxContainer/Game1Top.visible = true
	$HBoxContainer2.visible = true
	$HSeparator.visible = true
	$HBoxContainer/VBoxContainer/Game1Bot.visible = true
	$HBoxContainer/VBoxContainer/Game1Top.visible = true
	$HBoxContainer/VBoxContainer2/Game2Bot.visible = true
	$HBoxContainer/VBoxContainer2/Game2Top.visible = true
	
	$HBoxContainer2/VSeparator.visible = true
	$HBoxContainer2/VBoxContainer2.visible = true
	$HBoxContainer/VBoxContainer/Game1Bot.visible = true
	$HBoxContainer/VBoxContainer/Game1Top.visible = true
	$HBoxContainer/VBoxContainer2/Game2Bot.visible = true
	$HBoxContainer/VBoxContainer2/Game2Top.visible = true
	
	$HBoxContainer2/Game1Top2.visible = true
	$HBoxContainer2/Game1Top.visible = true
	if jobs.size() == 1:
		$HBoxContainer2.visible = false
		$HSeparator.visible = false
		$HBoxContainer/VBoxContainer2.visible = false
		$HBoxContainer/VSeparator.visible = false
		$HBoxContainer/VBoxContainer/Game1Bot.visible = false
		$HBoxContainer/VBoxContainer/Game1Top.visible = false
	elif jobs.size() == 2:
		$HBoxContainer2.visible = false
		$HSeparator.visible = false
	elif jobs.size() == 3:
		$HBoxContainer/VBoxContainer/Game1Bot.visible = false
		$HBoxContainer/VBoxContainer/Game1Top.visible = false
		$HBoxContainer/VBoxContainer2/Game2Bot.visible = false
		$HBoxContainer/VBoxContainer2/Game2Top.visible = false
		
		$HBoxContainer2/VSeparator.visible = false
		$HBoxContainer2/VBoxContainer2.visible = false
	else:
		$HBoxContainer/VBoxContainer/Game1Bot.visible = false
		$HBoxContainer/VBoxContainer/Game1Top.visible = false
		$HBoxContainer/VBoxContainer2/Game2Bot.visible = false
		$HBoxContainer/VBoxContainer2/Game2Top.visible = false
		
		$HBoxContainer2/Game1Top2.visible = false
		$HBoxContainer2/Game1Top.visible = false
	for i in jobs.size():
		var job = jobs[i]
		if jobs.size() > 1:
			job.scale = Vector2.ONE * 0.5
		if games[i].get_child_count() > 0:
			continue
		job.job_index = i
		GameManager.current_jobs.append(GameManager.upgrades[job.job_name].duplicate(true))
		print(GameManager.current_jobs)
		job.connect("score", _on_score)
		job.connect("level_up", on_level_up)
		games[i].add_child(job)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_jobs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_score(value):
	emit_signal('score', value)

func on_level_up(job_index):
	emit_signal('level_up', job_index)
