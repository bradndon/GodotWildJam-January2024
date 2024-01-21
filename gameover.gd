extends Node2D

@export var score = 0
@export var payments = 0
var play_time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func format(n):
	n = str(n)
	var size = n.length()
	var s = ""
	
	for i in range(size):
			if((size - i) % 3 == 0 and i > 0):
				s = str(s,",", n[i])
			else:
				s = str(s,n[i])
			
	return s



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var min = ceili(play_time) / 60
	var sec = ceili(play_time) % 60
	if score >= 2500:
		$Paid.visible = true
		$Panel/Label.text = "Payments Made: %s\nPaid: $%s\nTook: %02d:%02d" % [format(payments), format(score), min, sec]
	else:
		$Panel/Label.text = "Survived: %02d:%02d\nPayments Made: %s\nPaid: $%s\nStill Owed: $%s" % [min, sec, format(payments), format(score), format(2500-score)]
