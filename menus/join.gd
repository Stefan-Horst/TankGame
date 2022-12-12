extends Control

signal join_game()
signal back_main_menu(caller)

onready var line_edit_join = $"%LineEditJoin"
onready var btn_join = $"%BtnJoin"


func _process(_delta):
	if line_edit_join.text == "":
		btn_join.disabled = true
	else:
		btn_join.disabled = false


func _on_BtnJoin_pressed():
	emit_signal("join_game")


func _on_BtnBack_pressed():
	emit_signal("back_main_menu", self)
