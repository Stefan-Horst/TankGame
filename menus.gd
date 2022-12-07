extends Control

var pause_menu_active = false

onready var main_menu = $MainMenu
onready var settings_menu = $Settings
onready var pause_menu = $Pause

func _on_MainMenu_settings_menu():
	main_menu.visible = false
	settings_menu.visible = true
	settings_menu.btn_steering_mode.grab_focus()


func _on_Settings_settings_back():
	settings_menu.visible = false
	main_menu.visible = true
	main_menu.btn_start_game.grab_focus()


func _on_show_pause_menu():
	if not pause_menu_active:
		# game stays visible in background
		pause_menu.visible = true
		pause_menu.btn_continue.grab_focus()
	else:
		pause_menu.visible = false
	pause_menu_active = not pause_menu_active
