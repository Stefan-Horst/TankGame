extends Control

signal start_game()
signal settings_menu()

func _on_BtnStartGame_pressed():
	emit_signal("start_game")


func _on_BtnQuit_pressed():
	## quit game properly
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_BtnSettings_pressed():
	emit_signal("settings_menu")
