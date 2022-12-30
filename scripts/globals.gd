### autoload

extends Node


enum MENU {
	MAIN,
	SETTINGS,
	GAME_JOIN,
	GAME_HOST,
	GAME_LOBBY,
	INGAME_PAUSE,
}

var last_menu
var current_lobby_name = ""
# public ip address
var ip_address = ""


func _ready():
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
	print("public ip address is: ", ip_address)
	
	ip_address = "127.0.0.1" #TODO remove later
