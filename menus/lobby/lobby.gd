extends Menu


signal host_start_game()
signal lobby_exited()

var player_infos = []
#var player_iterator
var ip_address
#var player_is_host
var sufficient_players = false

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
	#player_infos.front().show_connected()


func initialize(): #TODO not complete yet
	.initialize()
	container_address.visible = false
	btn_start.visible = false
	label_title.text = Globals.current_lobby_name
	#player_iterator = 1
	
	if Globals.is_host:#Globals.last_menu == Globals.MENU.GAME_HOST:
		#player_is_host = true
		#show_address()
		
		## show ip address for host to copy
		ip_address = Globals.ip_address
		label_address.text = ip_address
		container_address.visible = true
		btn_copy.grab_focus()
	#else:
		#player_is_host = false


func reset():
	.reset()
	_reset_player_infos()
	label_title.text = ""
	sufficient_players = false
	emit_signal("lobby_exited")


func set_next_player(id, player_name, role):
	var player_iterator = 0
	while player_iterator < player_infos.size():
		if String(player_infos[player_iterator].id) == "-1":
			player_infos[player_iterator].id = id
			player_infos[player_iterator].set_name(player_name)
			player_infos[player_iterator].set_role(role)
			player_infos[player_iterator].show_connected()
			break
		player_iterator += 1
	
	if sufficient_players:
		btn_start.visible = true


func remove_player(id):
	var pos = -1
	## remove player_info with id
	# emulate player_infos[player_infos.find(p -> p.id == id)].hide()
	for i in range(0, player_infos.size()):
		if player_infos[i].id == id:
			player_infos[i].hide()
			pos = i
			break
	
	if pos == -1 or pos == player_infos.size() - 1:
		return
	
	## move all player_infos after removed player_info up one spot
	for i in range(pos, player_infos.size() - 1):
		if player_infos[i].id == -1:
			# find next non-empty player_info
			var j = i + 1
			while player_infos[j].id == -1:
				j += 1
				if j == player_infos.size():
					break
			# break for-loop as well if there are no more player_infos
			if j == player_infos.size():
				break
			
			player_infos[i].id = player_infos[j].id
			player_infos[i].label_name.text = player_infos[j].get_name()
			player_infos[i].set_role(player_infos[j].get_role())
			player_infos[i].show_connected()
			
			player_infos[j].hide()
	
	#player_iterator -= 1


func _reset_player_infos():
	for player_info in player_infos:
		player_info.hide()


#func show_address():
#	ip_address = Globals.ip_address
#	label_address.text = ip_address
#	container_address.visible = true
#	btn_copy.grab_focus()


#func show_start_button(): #TODO
	#btn_start.visible = true


func _on_BtnCopy_pressed():
	## copy lobby ip address to clipboard
	OS.clipboard = label_address.text


func _on_BtnStart_pressed():
	emit_signal("host_start_game")
