extends Control

var menus
var current_menu
# contains previously displayed menus from oldest to newest (last menu at back)
var previous_menus = []

onready var main_menu = $MainMenu
onready var join_menu = $GameJoin
onready var host_menu = $GameHost
onready var lobby_menu = $GameLobby
onready var settings_menu = $Settings


func _ready():
	menus = {
		Globals.MENU.MAIN : main_menu,
		Globals.MENU.SETTINGS : settings_menu,
		Globals.MENU.GAME_JOIN : join_menu,
		Globals.MENU.GAME_HOST : host_menu,
		Globals.MENU.GAME_LOBBY : lobby_menu,
	}
	
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
	active_menu.initialize()


func back_to_last_menu():
	change_to_menu(previous_menus.pop_back())
	# delete element added in change_to_menu()
	previous_menus.pop_back()
