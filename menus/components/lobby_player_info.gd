extends PanelContainer


# %s is placeholder
const TEXT_PLAYER = "Player %s:"
const TEXT_NAME = "Name: %s"

var id = -1

onready var label_player = $MarginContainer/VBoxContainer/LabelPlayer
onready var label_name = $MarginContainer/VBoxContainer/LabelName
onready var label_role = $MarginContainer/VBoxContainer/LabelRole


func _ready():
	modulate = Color(0) # basically invisible


func set_player(number):
	label_player.text = TEXT_PLAYER % number


func set_name(name_player):
	#if not name_player.begins_with("Name: "):
	label_name.text = TEXT_NAME % name_player


func set_role(role):
	label_role.text = role


func get_name():
	return label_name.text


func get_role():
	return label_role.text


func show_connected():
	modulate = Color("ffffff") # reset modulation


func hide():
	id = -1
	set_name("")
	set_role("")
	_ready()
