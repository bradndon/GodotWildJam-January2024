extends VBoxContainer

signal pick_job(scene)

# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/Job1.connect("pressed", on_job_select.bind("res://sigil.tscn")) # Replace with function body.
	$HBoxContainer/Job2.connect("pressed", on_job_select.bind("res://flames.tscn")) # Replace with function body.

func on_job_select(scene):
	emit_signal("pick_job", scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
