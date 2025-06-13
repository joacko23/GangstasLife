extends CanvasLayer

var settings_menu_screen = preload("res://ui/settings_menu_screen.tscn")

func _on_play_button_pressed():
	GameManager.start_game()
	AudioController.play_select()
	queue_free()


func _on_exit_button_pressed():
	AudioController.play_select()
	await get_tree().create_timer(0.7).timeout
	GameManager.exit_game()


func _on_settings_button_2_pressed():
	AudioController.play_select()
	var settings_menu_screen_instance = settings_menu_screen.instantiate()
	get_tree().get_root().add_child(settings_menu_screen_instance)
