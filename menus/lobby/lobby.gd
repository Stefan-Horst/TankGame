extends Menu


signal host_start_game()
signal lobby_exited()

var player_infos = []
var ip_address

onready var label_title = $"%LabelTitle"
onready var container_address = $"%HBConAddress"
onready var label_address = $"%LabelAddress"
onready var btn_copy = $"%BtnCopy"
onready var btn_start = $"%BtnStart"
onready var btn_back = $"%BtnBack"


func _ready():
	player_infos = get_tree().get_nodes_in_group("player")
	
	## give players numbers
	for i in player_infos.size():
		player_infos[i].set_player(i + 1)


func initialize():
	.initialize()
	container_address.visible = false
	btn_start.visible = false
	label_title.text = Globals.current_lobby_name
	
	if Globals.is_host:
		## show ip address for host to copy
		ip_address = Globals.ip_address
		label_address.text = ip_address
		container_address.visible = true
		btn_copy.grab_focus()


func reset():
	.reset()
	_reset_player_infos()
	label_title.text = ""
	Globals.current_lobby_name = ""
	emit_signal("lobby_exited")


## add new player to lobby, place it in next free slot
func set_next_player(id, player_name, role):
	var player_iterator = 0
	while player_iterator < player_infos.size():
		var player = player_infos[player_iterator]
		if String(player.id) == "-1":
			player.id = id
			player.set_name(player_name)
			player.set_role(role)
			player.show_connected()
			if id == Globals.player_id or (Globals.is_host and id == 1):
				player.set_own_player()
			break
		player_iterator += 1
	
	if Globals.is_host and Globals.current_player_amount == Globals.SUFFICIENT_PLAYERS:
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
	
	if Globals.current_player_amount < Globals.SUFFICIENT_PLAYERS:
		btn_start.visible = false


func _reset_player_infos():
	for player_info in player_infos:
		player_info.hide()


func _on_BtnCopy_pressed():
	## copy lobby ip address to clipboard
	OS.clipboard = label_address.text


func _on_BtnStart_pressed():
	emit_signal("host_start_game")
