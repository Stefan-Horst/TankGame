extends Control

signal change_steering_mode(mode)
## back to main menu
signal settings_back()

# normal = true; inverted = false
var steering_mode = true

onready var btn_steering_mode = $VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainerSteeringMode/BtnSteeringMode

func _on_BtnSteeringMode_pressed():
	steering_mode = not steering_mode
	if steering_mode:
		btn_steering_mode.text = "normal"
	else:
		btn_steering_mode.text = "inverted"
	emit_signal("change_steering_mode", steering_mode)


func _on_BtnBack_pressed():
	emit_signal("settings_back")
