extends Control

var pause_menu_active = false

onready var main_menu = $MainMenu
onready var join_menu = $GameJoin
onready var host_menu = $GameHost
onready var settings_menu = $Settings
onready var pause_menu = $IngamePause


func _on_MainMenu_join_game():
	main_menu.visible = false
	join_menu.visible = true
	join_menu.line_edit_join.grab_focus()


func _on_MainMenu_host_game():
	main_menu.visible = false
	host_menu.visible = true
	host_menu.hide_address()
	host_menu.line_edit_name.grab_focus()


func _on_MainMenu_settings_menu():
	main_menu.visible = false
	settings_menu.visible = true
	settings_menu.btn_steering_mode.grab_focus()


func _on_back_main_menu(caller):
	caller.visible = false
	main_menu.visible = true
	main_menu.btn_join_game.grab_focus()


func _on_JoinGame_join_game():
	pass # Replace with function body.


func _on_HostGame_host_game(name_lobby):
	host_menu.show_address("TODO")


func _on_show_pause_menu():
	if not pause_menu_active:
		# game stays visible in background
		pause_menu.visible = true
		pause_menu.btn_continue.grab_focus()
	else:
		pause_menu.visible = false
	
	pause_menu_active = not pause_menu_active
