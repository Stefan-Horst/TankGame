### autoload

extends Node


enum MENU {
	MAIN,
	SETTINGS,
	GAME_JOIN,
	GAME_HOST,
	GAME_LOBBY,
}

const MAX_PLAYERS = 4
const SUFFICIENT_PLAYERS = 2

var last_menu
var current_lobby_name = ""
var current_player_amount = 1
# public ip address
var ip_address = ""
var is_host = false
var player_id = -1


func _ready():
	# set pause mode for children to inherit it and still process if tree is paused
	pause_mode = Node.PAUSE_MODE_PROCESS
	init_ip_address()


## request public ip address
func init_ip_address():
	ip_address = "error" # maybe keep "old" ip
	
	var http_request = HTTPRequest.new()
	http_request.timeout = 10
	
	add_child(http_request)
	http_request.connect("request_completed", self, "on_get_ip_address")
	# rather trustworthy site for getting public ip as plain text
	http_request.request("https://api.ipify.org")


## get public ip address as response to request; called via signal
func on_get_ip_address(_result, response_code, _headers, body):
	if not response_code == 200:
		init_ip_address()
		return
	
	ip_address = body.get_string_from_utf8()
	print("Public IP address is: ", ip_address)
	
	ip_address = "127.0.0.1" #TODO remove later
