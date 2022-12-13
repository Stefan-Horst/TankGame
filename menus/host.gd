extends Control

signal host_game(lobby_name)
signal back_main_menu(caller)

var ip_address

onready var line_edit_name = $"%LineEditName"
onready var container_address = $"%HBConAddress"
onready var label_address = $"%LabelAddress"
onready var btn_copy = $"%BtnCopy"


func show_address():
	ip_address = Globals.ip_address
	
	if not ip_address == "error":
		label_address.text = ip_address
	else:
		label_address.text = "Error getting IP, try again"
	
	container_address.visible = true
	btn_copy.visible = true
	btn_copy.grab_focus()


func hide_address():
	container_address.visible = false
	label_address.text = ""


func _on_BtnHost_pressed():
	show_address()
	
	var lobby_name = line_edit_name.text
	
	if ip_address == "error":
		# no lobby and no copy button needed if ip unknown
		btn_copy.visible = false
		return
	elif not lobby_name:
		# set lobby name to hosts ip if no name entered
		lobby_name = ip_address + "'s Lobby"
	
	emit_signal("host_game", lobby_name)


func _on_BtnCopy_pressed():
	## copy lobby ip address to clipboard
	OS.clipboard = label_address.text


func _on_BtnBack_pressed():
	emit_signal("back_main_menu", self)
