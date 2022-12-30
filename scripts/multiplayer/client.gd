extends Networking

class_name Client


signal disconnected_by_server()
signal set_lobby_name(lobby_name)
signal set_remote_players(players)

#var server_ip
#var server


func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")


func start_connection(server_ip):
	var peer = NetworkedMultiplayerENet.new()
	var status = peer.create_client(server_ip, port)
	
	if status == OK:
		print("Client connected to server")
	else:
		print("Error connecting client with status: %s" % status)
	
	Globals.get_tree().network_peer = peer
	#server = players[0]


func stop_connection():
	Globals.get_tree().network_peer.close_connection()
	yield(get_tree(), "idle_frame")
	Globals.get_tree().network_peer = null
	players = []
	print("Connection to server stopped")


func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.


func _server_disconnected():
	emit_signal("disconnected_by_server")
	#stop_connection()
	pass # Server kicked us; show error and abort.


func _connected_fail():
	pass # Could not even connect to server; abort.


remote func set_lobby_name(lobby_name):
	emit_signal("set_lobby_name", lobby_name)


remote func set_remote_players(players):
	emit_signal("set_remote_players", players)
