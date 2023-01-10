extends Networking

class_name Client


signal disconnected_by_server()
signal set_lobby_name(lobby_name)
signal set_remote_players(players)
signal prepare_game()
signal start_game()


func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok") #warning-ignore:RETURN_VALUE_DISCARDED
	get_tree().connect("connection_failed", self, "_connected_fail") #warning-ignore:RETURN_VALUE_DISCARDED
	get_tree().connect("server_disconnected", self, "_server_disconnected") #warning-ignore:RETURN_VALUE_DISCARDED


func start_connection(server_ip):
	var peer = NetworkedMultiplayerENet.new()
	var status = peer.create_client(server_ip, port)
	
	if status == OK:
		print("Client connected to server")
	else:
		print("Error connecting client with status: %s" % status)
	
	Globals.get_tree().network_peer = peer
	Globals.player_id = get_tree().get_network_unique_id()


func stop_connection():
	Globals.get_tree().network_peer.close_connection()
	yield(get_tree(), "idle_frame")
	Globals.get_tree().network_peer = null
	
	print("Connection to server stopped")
	
	Globals.player_id = -1
	players = []


func notify_client_ready():
	# rpc only sent to server
	rpc_id(1, "set_client_ready")


# connection to server successful
func _connected_ok():
	pass


func _server_disconnected():
	emit_signal("disconnected_by_server")


# client could not connect to server
func _connected_fail():
	pass


remote func set_lobby_name(lobby_name):
	emit_signal("set_lobby_name", lobby_name)


remote func set_remote_players(players):
	emit_signal("set_remote_players", players)


remote func prepare_game(player_infos):
	assert(player_infos.size() == Globals.current_player_amount)
	emit_signal("prepare_game", player_infos)


remote func start_game():
	emit_signal("start_game")
	print("Game starting")
