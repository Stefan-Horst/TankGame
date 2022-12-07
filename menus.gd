extends Control

onready var main_menu = $MainMenu
onready var settings_menu = $Settings

func _on_MainMenu_settings_menu():
	main_menu.visible = false
	settings_menu.visible = true
	settings_menu.btn_steering_mode.grab_focus()


func _on_Settings_settings_back():
	settings_menu.visible = false
	main_menu.visible = true
	main_menu.btn_start_game.grab_focus()
