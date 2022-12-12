extends Control

signal join_game()
signal host_game()
signal start_game()
signal settings_menu()
signal quit()

onready var btn_join_game = $"%BtnJoinGame"


func _on_BtnJoinGame_pressed():
	emit_signal("join_game")


func _on_BtnHostGame_pressed():
	emit_signal("host_game")


func _on_BtnStartSandbox_pressed():
	emit_signal("start_game")


func _on_BtnSettings_pressed():
	emit_signal("settings_menu")


func _on_BtnQuit_pressed():
	emit_signal("quit")

