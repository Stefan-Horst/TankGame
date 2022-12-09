extends Node2D

signal menu_pause()

var player_can_shoot = true

onready var player = $Player
onready var cooldown_timer = player.get_node("TimerGunCooldown")
onready var enemies = $Enemies


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and self.visible:
		emit_signal("menu_pause")


func _on_shoot_projectile(Projectile, caller, location, direction):
	## let player only shoot if gun not on cooldown
	if caller.name == "Player":
		if player_can_shoot:
			player_can_shoot = false
		else:
			return
	
	## create projectile
	var p = Projectile.instance()
	add_child(p)
	
	p.emitter = caller.name
	p.position = location
	p.rotation = direction
	p.velocity = p.velocity.rotated(direction)
	
	## add signal to enemies or to player depending on who shot
	if caller.name == "Player":
		for enemy in _get_all_enemies():
			p.connect("entity_hit", enemy, "_on_entity_hit")
		
		cooldown_timer.wait_time = caller.cooldown
		cooldown_timer.start()
	else:
		p.connect("entity_hit", player, "_on_entity_hit")


## return list of all child nodes of node "Enemies"
func _get_all_enemies():
	var enemies_list = []
	for i in enemies.get_child_count():
		enemies_list.append(enemies.get_child(i))
	return enemies_list


func _on_TimerCooldown_timeout():
	player_can_shoot = true
