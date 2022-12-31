### abstract class

extends Node

class_name Networking


# number is position of player id in players array
signal player_connected(number)
signal player_disconnected(number)

# random port number which is not already reserved
const STANDARD_PORT = 43804

var port = STANDARD_PORT
var players = []
var player_id = -1


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected") #warning-ignore:RETURN_VALUE_DISCARDED
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected") #warning-ignore:RETURN_VALUE_DISCARDED


func _player_connected(id):
	if player_id == -1:
		player_id = get_tree().get_network_unique_id()
	
	rpc_id(id, "register_player")


func _player_disconnected(id):
	players.erase(id)
	
	if id == player_id:
		player_id = -1
	
	print("Player disconnected: %s" % id)
	print("All players: " + String(players))
	emit_signal("player_disconnected", id)


## add new players unique network id to player list
remote func register_player():
	var id = get_tree().get_rpc_sender_id()
	players.append(id)
	print("New player connected: %s" % id)
	print("All players: " + String(players))
	emit_signal("player_connected", id)


func disconnect_player(id): #TODO put in server?
	get_tree().network_peer.disconnect_peer(id)
	players.erase(id)
