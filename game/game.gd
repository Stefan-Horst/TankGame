extends Node2D


signal menu_pause()
signal game_ended()

const MAX_PLAYERS = 4

var enemies = []
var enemies_alive = []
var spawn_positions = []
var actors = [] # all tanks in the game
var player_can_shoot = true

onready var map = $Map
onready var player = $Player
onready var cooldown_timer = player.get_node("TimerGunCooldown")


func _ready():
	enemies = get_tree().get_nodes_in_group("enemy")


func _process(_delta):
	## show "pause menu" overlay when esc key is pressed
	if Input.is_action_just_pressed("ui_cancel") and self.visible:
		emit_signal("menu_pause")


func init_game(amount_players): #TODO add map param
	## reset values (from last game)
	spawn_positions = []
	enemies_alive = []
	actors = []
	
	## init amount actual enemies equals amount real other players
	for i in amount_players - 1:
		enemies_alive.append(enemies[i])
	
	actors.append(player)
	actors.append_array(enemies_alive)
	
	player.enemies = enemies_alive
	
	## init list spawn_positions
	var sp = map.get_node("SpawnPositions")
	for i in sp.get_child_count():
		spawn_positions.append(sp.get_child(i))
	
	## assign every tank a random spawn_position
	var spawn_order = []
	for i in range(0, actors.size()):
		spawn_order.append(i)
	
	randomize()
	spawn_order.shuffle()
	
	for i in actors.size():
		actors[i].position = spawn_positions[spawn_order[i]].position
		actors[i].visible = true


func end_game():
	for i in actors.size():
		actors[i].remove_from_game() # maybe only call for last survivor
	
	emit_signal("game_ended")


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
		for enemy in enemies:
			p.connect("entity_hit", enemy, "_on_entity_hit")
		
		cooldown_timer.wait_time = caller.cooldown
		cooldown_timer.start()
	else:
		p.connect("entity_hit", player, "_on_entity_hit")


func _on_enemy_destroyed(caller):
	enemies_alive.erase(caller)
	player.enemies = enemies_alive
	
	if enemies_alive.size() == 0:
		end_game()


func _on_TimerCooldown_timeout():
	player_can_shoot = true
