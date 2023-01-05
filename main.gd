extends Node


onready var game = $Game
onready var menus = $Menus
onready var menu_main = menus.get_node("MainMenu")
onready var menu_pause = menus.get_node("IngamePause")
onready var menu_lobby = menus.get_node("GameLobby")

var server = Server.new()
var client = Client.new()
var game_active = false


func _ready():
	get_tree().paused = true
	menu_main.btn_join_game.grab_focus()
	
	server.connect("player_connected", self, "_player_connected")
	server.connect("player_disconnected", self, "_player_disconnected")
	client.connect("player_connected", self, "_server_connected")
	client.connect("disconnected_by_server", self, "_disconnected_by_server")
	client.connect("player_disconnected", self, "_server_disconnected")
	client.connect("set_remote_players", self, "_set_remote_players")
	client.connect("set_lobby_name", self, "_set_lobby_name")


func _on_MainMenu_start_game():
	menu_main.visible = false
	game.visible = true
	game.init_game(4) #TODO dynamic value
	get_tree().paused = false


func _on_GameHost_host_game():
	Globals.is_host = true
	add_child(server)
	server.set_name("networker")
	server.call_deferred("start_server")
	menu_lobby.set_next_player(1, "1", "Host")
	menus.change_to_menu(Globals.MENU.GAME_LOBBY)
	menu_lobby.btn_back.text = "Quit"


func _on_GameJoin_join_game(address):
	Globals.is_host = false
	add_child(client)
	client.set_name("networker")
	client.call_deferred("start_connection", address)
	menus.change_to_menu(Globals.MENU.GAME_LOBBY)
	menu_lobby.btn_back.text = "Leave"


## other player connected to this host
func _player_connected(id):
	menu_lobby.set_next_player(id, id, "Guest") #TODO change id to name


## other player disconnected from this host
func _player_disconnected(id):
	menu_lobby.remove_player(id)


## this player connected to host
func _server_connected(id):
	if id == 1:
		menu_lobby.set_next_player(id, id, "Host") #TODO change id to name


## host closed connection / kicked this player
func _disconnected_by_server():
	menus.back_to_last_menu()


## another player disconnected from host
func _server_disconnected(id):
	menu_lobby.remove_player(id)


func _set_lobby_name(lobby_name):
	Globals.current_lobby_name = lobby_name
	menu_lobby.label_title.text = lobby_name


## add other non-host players to client's lobby
func _set_remote_players(players):
	var ids = []
	for p in menu_lobby.player_infos:
		ids.append(p.id)
	
	for player in players:
		if not player in ids and not String(player) == "1":
			menu_lobby.set_next_player(player, player, "Guest")


func _on_GameLobby_lobby_exited():
	Globals.current_player_amount = 1
	if Globals.is_host:
		server.stop_server()
		call_deferred("remove_child", server)
	else:
		client.stop_connection()
		call_deferred("remove_child", client)


func _on_GameLobby_host_start_game():
	pass #TODO start game


func _on_Pause_quit_game():
	get_tree().paused = true
	#game.end_game() necessary here?
	Globals.current_player_amount = 1
	menu_pause.visible = false
	game.visible = false
	menu_main.visible = true
	menus.pause_menu_active = false
	
	if Globals.is_host:
		server.stop_server()


func _on_Game_game_ended():
	get_tree().paused = true
	Globals.current_player_amount = 1
	game.visible = false
	menu_main.visible = true
	#TODO show post game leaderboard etc


func _on_MainMenu_quit():
	## quit game properly
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
