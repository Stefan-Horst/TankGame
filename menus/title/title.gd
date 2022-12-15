extends Menu

signal start_game()
signal quit()

onready var btn_join_game = $"%BtnJoinGame"


func initialize():
	.initialize()
	btn_join_game.grab_focus()


func _on_BtnJoinGame_pressed():
	change_to_menu(Globals.MENU.GAME_JOIN)


func _on_BtnHostGame_pressed():
	change_to_menu(Globals.MENU.GAME_HOST)


func _on_BtnStartSandbox_pressed():
	emit_signal("start_game")


func _on_BtnSettings_pressed():
	change_to_menu(Globals.MENU.SETTINGS)


func _on_BtnQuit_pressed():
	emit_signal("quit")
