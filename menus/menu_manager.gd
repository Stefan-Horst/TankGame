extends Control

var menus
var current_menu
# contains previously displayed menus from oldest to newest (last menu at back)
var previous_menus = []
var pause_menu_active = false

onready var main_menu = $MainMenu
onready var join_menu = $GameJoin
onready var host_menu = $GameHost
onready var lobby_menu = $GameLobby
onready var settings_menu = $Settings
onready var pause_menu = $IngamePause


func _ready():
	menus = {
		Globals.MENU.MAIN : main_menu,
		Globals.MENU.SETTINGS : settings_menu,
		Globals.MENU.GAME_JOIN : join_menu,
		Globals.MENU.GAME_HOST : host_menu,
		Globals.MENU.GAME_LOBBY : lobby_menu,
		Globals.MENU.INGAME_PAUSE : pause_menu,
	}
	
	#previous_menus.append(Globals.MENU.MAIN)
	current_menu = Globals.MENU.MAIN


# param has to be of MENU enum type
func change_to_menu(menu):
	Globals.last_menu = current_menu
	previous_menus.append(current_menu)
	current_menu = menu
	
	var active_menu = menus[current_menu]
	var last_active_menu = menus[previous_menus.back()]
	last_active_menu.visible = false
	active_menu.visible = true
	
	last_active_menu.reset()
	#if active_menu.has_method("initialize"):
	active_menu.initialize()


func back_to_last_menu():
	change_to_menu(previous_menus.pop_back())
	# delete element added in change_to_menu()
	previous_menus.pop_back()
"""
### open sub-menus of main menu

func _on_MainMenu_join_game():
	main_menu.visible = false
	join_menu.visible = true
	join_menu.line_edit_join.grab_focus()


func _on_MainMenu_host_game():
	main_menu.visible = false
	host_menu.visible = true
	host_menu.label_address.visible = false
	host_menu.line_edit_name.grab_focus()


func _on_MainMenu_settings_menu():
	main_menu.visible = false
	settings_menu.visible = true
	settings_menu.btn_steering_mode.grab_focus()


## go back to main menu from sub-menus
func _on_back_main_menu(caller):
	caller.visible = false
	main_menu.visible = true
	main_menu.btn_join_game.grab_focus()


## go back to sub-menu from sub-sub-menus
func _on_back_last_menu(caller):
	caller.visible = false
	
	if caller.name == "GameLobby":
		if caller.player_is_host:
			_on_MainMenu_host_game() #TODO fix kinda dirty implementation
		else:
			_on_MainMenu_join_game()


### change menu from sub-menu

func _on_GameJoin_join_game():
	host_menu.visible = false
	lobby_menu.reset()
	lobby_menu.visible = true #TODO only show after connecting successful


func _on_GameHost_host_game(lobby_name):
	host_menu.visible = false
	lobby_menu.visible = true
	lobby_menu.lobby_name = lobby_name
	lobby_menu.player_is_host = true
"""

## open pause menu when in game
func _on_show_pause_menu():
	if not pause_menu_active:
		# game stays visible in background
		pause_menu.visible = true
		pause_menu.btn_continue.grab_focus()
	else:
		pause_menu.visible = false
	
	pause_menu_active = not pause_menu_active
