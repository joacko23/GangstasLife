extends CanvasLayer



func _on_continue_button_pressed():
	GameManager.continue_game()
	AudioController.play_pause()
	queue_free()


func _on_main_menu_button_pressed():
	GameManager.main_menu()
	AudioController.play_select()
	queue_free()



