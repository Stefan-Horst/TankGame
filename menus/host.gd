extends Control

signal host_game(name_lobby)
signal back_main_menu(caller)

var ip_adress = ""

onready var line_edit_name = $"%LineEditName"
onready var line_address = $"%LineEditAddress"
onready var container_address = $"%HBConAddress"


func show_address(address):
	line_address.text = address
	container_address.visible = true


func hide_address():
	container_address.visible = false
	line_address.text = ""


func _on_BtnHost_pressed():
	var name_lobby = line_edit_name.text
	
	# just set lobby name to hosts ip if no name entered
	if not name_lobby:
		name_lobby = ip_adress
	
	emit_signal("host_game", name_lobby)


func _on_BtnBack_pressed():
	emit_signal("back_main_menu", self)
