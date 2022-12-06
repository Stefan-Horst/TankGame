extends Node

onready var game = $Game
onready var menu_main = $Menus/MainMenu

func _on_MainMenu_start_game():
	game.visible = true
	menu_main.visible = false
