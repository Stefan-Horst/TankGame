extends Menu

#signal host_game(lobby_name)

onready var line_edit_name = $"%LineEditName"
onready var label_address = $"%LabelAddress"


func initialize():
	.initialize()
	label_address.visible = false
	line_edit_name.grab_focus()


func _on_BtnHost_pressed():
	var lobby_name = line_edit_name.text
	var ip_address = Globals.ip_address
	
	if ip_address == "error":
		# no lobby needed if ip unknown, show label with default error message
		label_address.visible = true
		return
	elif lobby_name == "":
		# set lobby name to hosts ip if no name entered
		lobby_name = ip_address + "'s Lobby"
	
	#emit_signal("host_game", lobby_name)
	Globals.current_lobby_name = lobby_name
	
	change_to_menu(Globals.MENU.GAME_LOBBY)
