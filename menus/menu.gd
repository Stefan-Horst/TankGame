### abstract class

extends Control

class_name Menu


signal change_to_menu(menu)
signal back_to_last_menu()


## called when menu is displayed
func initialize():
	self.visible = true


## called when another menu is displayed
func reset():
	self.visible = false


func change_to_menu(menu):
	emit_signal("change_to_menu", menu)


func back_to_last_menu():
	emit_signal("back_to_last_menu")
