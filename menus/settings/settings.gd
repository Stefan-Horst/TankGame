extends Control

signal change_steering_mode(mode)
signal back_main_menu(caller)

# normal = false; inverted = true
var steering_mode = false

onready var btn_steering_mode = $"%BtnSteeringMode"


func _on_BtnSteeringMode_pressed():
	steering_mode = not steering_mode
	if steering_mode:
		btn_steering_mode.text = "inverted"
	else:
		btn_steering_mode.text = "normal"
	emit_signal("change_steering_mode", steering_mode)


func _on_BtnBack_pressed():
	emit_signal("back_main_menu", self)