extends Node2D

@export var next_scene : String



func _on_exit_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		AudioController.play_end_level()
		var player = body as CharacterBody2D
		player.queue_free()
		
	await get_tree().create_timer(2.0).timeout
	SceneManager.transition_to_scene(next_scene)
