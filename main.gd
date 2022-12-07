extends Node

onready var game = $Game
onready var menus = $Menus
onready var menu_main = $Menus/MainMenu
onready var menu_pause = $Menus/Pause

func _ready():
	menu_main.btn_start_game.grab_focus()


func _on_MainMenu_start_game():
	menu_main.visible = false
	game.visible = true


func _on_Pause_quit_game():
	menu_pause.visible = false
	game.visible = false
	menu_main.visible = true
	menus.pause_menu_active = false


func _on_MainMenu_quit():
	## quit game properly
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
