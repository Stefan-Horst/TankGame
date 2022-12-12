extends Node

onready var game = $Game
onready var menus = $Menus
onready var menu_main = menus.get_node("MainMenu")
onready var menu_pause = menus.get_node("IngamePause")


func _ready():
	menu_main.btn_join_game.grab_focus()


func _on_MainMenu_start_game():
	menu_main.visible = false
	game.visible = true
	game.init_game(4) #TODO dynamic value


func _on_Pause_quit_game():
	game.end_game()
	menu_pause.visible = false
	game.visible = false
	menu_main.visible = true
	menus.pause_menu_active = false


func _on_Game_game_ended():
	game.visible = false
	menu_main.visible = true
	# TODO show post game leaderboard etc


func _on_MainMenu_quit():
	## quit game properly
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
