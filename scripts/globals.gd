extends Node

var ip_address = ""


func _ready():
	init_ip_address()


## request public ip address
func init_ip_address():
	ip_address = "error" # maybe keep "old" ip
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "on_get_ip_address")
	# rather trustworthy site for getting public ip as plain text
	http_request.request("https://api.ipify.org")


## get public ip address as response to request; called via signal
func on_get_ip_address(_result, response_code, _headers, body):
	if response_code == 200:
		ip_address = body.get_string_from_utf8()
	
	print("public ip address is: ", ip_address)
