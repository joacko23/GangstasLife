extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color(0.33, 0.41, 0.53, 1.00))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
