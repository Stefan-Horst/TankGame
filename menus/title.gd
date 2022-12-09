extends Control

signal start_game()
signal quit()
signal settings_menu()

onready var btn_start_game = $"%BtnStartGame"


func _on_BtnStartGame_pressed():
	emit_signal("start_game")


func _on_BtnQuit_pressed():
	emit_signal("quit")


func _on_BtnSettings_pressed():
	emit_signal("settings_menu")
