extends Node

var character
var current_jobs = []
var seen_how_tos = []
var upgrades = {
	"flames": {
		"name": "Chef",
		"level": 1,
		"lives": 3,
		"base": 15,
		"baseup": [1,1,2,3,5],
		"up1_val": 0,
		"up1": ["Cook time +.5s\nComission +$1", "Speed +10%\nComission +$1"],
		"up2_val": 0,
		"up2": ["Speed -5%\nComission -$1", "Cook time -.25s\n Comission -$1"]
	},
	"sigil": {
		"name": "Teleporter",
		"level": 1,
		"lives": 3,
		"base": 10,
		"baseup": [1,1,2,3,5],
		"up1_val": 0,
		"up1": ["Rune Options +1\nComission +$1", "Transport Length +1\nComission +$1", "Rune Options +1\nComission +$1", "Transport Length +1\nComission +$1", "Rune Options +1\nComission +$1", "Rune Options +1\nComission +$1", "Transport Length +1\nComission +$1", "Transport Length +1\nComission +$1", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$", "Time -2s\nComission +1$"],
		"up2_val": 0,
		"up2": ["Time +1s\nComission -$1"]
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
