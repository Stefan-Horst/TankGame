### component

extends Button


func _ready():
	self.connect("pressed", self, "_on_back_button_pressed") #warning-ignore:RETURN_VALUE_DISCARDED


func _on_back_button_pressed():
	# back_to_last_menu() is function of abstract class menu.gd
	get_parent().back_to_last_menu()
