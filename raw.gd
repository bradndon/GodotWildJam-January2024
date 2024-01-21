extends CharacterBody2D


var  speed = 80.0
const JUMP_VELOCITY = -400.0
var uncooked = true
@export var cooktime = 1
var cooked_time = 0
var cooking = false
signal exit_screen(uncooked)
signal cooked
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	var x: Path2D = get_parent().get_parent()
	var length_per_hundredth = x.curve.get_baked_length() / 100
	var speed_this_frame = speed * delta
	var updated_prog = speed_this_frame / length_per_hundredth
	$Raw/TextureProgressBar.value = (cooked_time / cooktime) * 100

	get_parent().progress_ratio += (updated_prog / 100)

	if get_parent().progress_ratio >= 1:
		emit_signal("exit_screen", uncooked)
		get_parent().queue_free()
	if cooking:
		cook_a_bit(delta)
	# Add the gravity.
	
func cook_a_bit(amt):
	cooked_time += amt
	if uncooked and cooked_time >= cooktime:
		cook()

func cook():
	#modulate = Color(1,0,0,1)
	uncooked = false
	emit_signal("cooked")
	


func _on_raw_pressed():
	cook() # Replace with function body.


func _on_down():
	cooking = true
	$AudioStreamPlayer.play()
	$Raw/CPUParticles2D4.emitting = true


func _on_up():
	cooking = false
	$Raw/CPUParticles2D4.emitting = false
