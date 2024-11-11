extends CanvasLayer
@onready var window_mode_options_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/WindowModeOptionsButton
@onready var resolution_option_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResolutionOptionButton

var windows_modes : Dictionary = {"Fullscreen" : DisplayServer.WINDOW_MODE_FULLSCREEN,
								 "Window" : DisplayServer.WINDOW_MODE_WINDOWED,
								 "Window Maximized" : DisplayServer.WINDOW_MODE_MAXIMIZED }

var resolutions : Dictionary = {"320x180" : Vector2i(320, 180),
								 "480x270" : Vector2i(480, 270),
								 "640x360" : Vector2i(640, 360),
								 "854x480" : Vector2i(854, 480),
								 "1280x720" : Vector2i(1280, 720) }

func _ready():
	for window_mode in windows_modes:
		window_mode_options_button.add_item(window_mode)
	
	for resolution in resolutions:
		resolution_option_button.add_item(resolution)
	
	initialize_controls()


func initialize_controls():
	SettingsManager.load_settings()
	var settings_data : SettingsDataResource = SettingsManager.get_settings()
	window_mode_options_button.selected = settings_data.window_mode_index
	resolution_option_button.selected = settings_data.resolution_index


func _on_window_mode_options_button_item_selected(index):
	var window_mode = windows_modes.get(window_mode_options_button.get_item_text(index)) as int
	SettingsManager.set_window_mode(window_mode, index)


func _on_resolution_option_button_item_selected(index):
	var resolution = resolutions.get(resolution_option_button.get_item_text(index)) as Vector2i
	SettingsManager.set_resolution(resolution, index)


func _on_main_menu_button_pressed():
	SettingsManager.save_settings()
	queue_free()
