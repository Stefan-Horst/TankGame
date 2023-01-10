extends Networking

class_name Server


signal clients_ready()

var max_players = Globals.MAX_PLAYERS
var ready_players = []


func _ready():
	self.connect("player_connected", self, "_synchronize_lobby") #warning-ignore:RETURN_VALUE_DISCARDED


func start_server():
	var peer = NetworkedMultiplayerENet.new()
	var status = peer.create_server(port, max_players - 1)
	
	if status == OK:
		print("Server started")
	else:
		print("Error starting server with status: %s" % status)
	
	Globals.get_tree().network_peer = peer
	Globals.player_id = get_tree().get_network_unique_id()


func stop_server():
	for player in players:
		disconnect_player(player)
	
	yield(get_tree(), "idle_frame")
	Globals.get_tree().network_peer = null
	
	print("Server stopped")
	
	Globals.player_id = -1
	players = []


func start_game(players):
	## clients need to be ready before game can actually start
	rpc("prepare_game", players)
	print("Make clients prepare game with player positions: " + String(players))


remote func set_client_ready(): #TODO change from remote to master?
	ready_players.append(get_tree().get_rpc_sender_id())
	
	## start game if list of players contains same ids as list of ready players
	if ready_players.sort() == players.duplicate().sort():
		rpc("start_game")
		print("Game starting")
		emit_signal("clients_ready")


func _synchronize_lobby(id):
	if id == 1:
		return
	
	## send clients name of this host's lobby
	rpc_id(id, "set_lobby_name", Globals.current_lobby_name)
	
	## send clients list of all players connected to this host's lobby
	var names = ["1"] #TODO replace host with actual name
	names.append_array(players)
	rpc("set_remote_players", names)
