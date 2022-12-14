extends Control

signal host_game(lobby_name)
signal back_main_menu(caller)

onready var line_edit_name = $"%LineEditName"
onready var label_address = $"%LabelAddress"

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
	
	emit_signal("host_game", lobby_name)


func _on_BtnBack_pressed():
	emit_signal("back_main_menu", self)
