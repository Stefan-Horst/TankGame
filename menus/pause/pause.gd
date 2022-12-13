extends Control

signal menu_pause()
signal quit_game()

onready var btn_continue = $"%BtnContinue"


func _on_BtnContinue_pressed():
	# handle visibility of pause menu in menus.gd
	emit_signal("menu_pause")


func _on_BtnExit_pressed():
	emit_signal("quit_game")
