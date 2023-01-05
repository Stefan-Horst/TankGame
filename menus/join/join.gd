extends Menu


signal join_game(address)

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
	emit_signal("join_game", line_edit_join.text)
