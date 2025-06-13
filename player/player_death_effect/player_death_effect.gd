extends Node2D


func _ready():
	AudioController.play_death()

func _on_timer_timeout():
	get_tree().reload_current_scene()
	queue_free()
