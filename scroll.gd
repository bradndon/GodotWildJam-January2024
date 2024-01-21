extends Node2D

@export var runes: Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready():

	for i in runes.size():

		get_node(str(i + 1)).texture = runes[i]
	
	$AnimationPlayer.play("unroll" + str(runes.size()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
