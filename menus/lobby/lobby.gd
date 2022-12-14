extends Control

signal host_start_game()
signal back_last_menu(caller)

var player_infos = []
var player_iterator = 0
var ip_address
# is set from host menu via menus.gd
var lobby_name
var player_is_host = false setget set_is_host

onready var label_title = $"%LabelTitle"
onready var container_address = $"%HBConAddress"
onready var label_address = $"%LabelAddress"
onready var btn_copy = $"%BtnCopy"
onready var btn_start = $"%BtnStart"


func _ready():
	player_infos = get_tree().get_nodes_in_group("player")
	
	## give players numbers
	for i in player_infos.size():
		player_infos[i].set_player(i + 1)
	
	# this game instance is definitely in lobby, therefore show it
	player_infos[0].show_connected()


func reset(): #TODO not complete yet
	container_address.visible = false
	btn_start.visible = false
	player_is_host = false


func set_next_player(player_name, role):
	if player_iterator < player_infos.size():
		player_infos[player_iterator].set_name(player_name)
		player_infos[player_iterator].set_role(role)
		player_infos[player_iterator].show_connected()
	player_iterator += 1


func show_address():
	ip_address = Globals.ip_address
	label_address.text = ip_address
	container_address.visible = true
	btn_start.visible = true #TODO only show after at least one player has joined
	btn_copy.grab_focus()


func show_start_button(): #TODO
	btn_start.visible = true


## setter of player_is_host
## shows/hides players ip address depending on whether he is the host or not
func set_is_host(is_host):
	player_is_host = is_host
	
	if player_is_host:
		show_address()
		label_title.text = lobby_name


func _on_BtnCopy_pressed():
	## copy lobby ip address to clipboard
	OS.clipboard = label_address.text


func _on_BtnStart_pressed():
	emit_signal("host_start_game")


func _on_BtnBack_pressed():
	emit_signal("back_last_menu", self)
