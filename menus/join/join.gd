extends Menu

signal back_main_menu(caller)

onready var line_edit_join = $"%LineEditJoin"
onready var btn_join = $"%BtnJoin"


func _process(_delta):
	if line_edit_join.text == "":
		btn_join.disabled = true
	else:
		btn_join.disabled = false


func initialize():
	.initialize()
	line_edit_join.grab_focus()


func _on_BtnJoin_pressed():
	change_to_menu(Globals.MENU.GAME_LOBBY)
