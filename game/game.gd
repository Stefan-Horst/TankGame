extends Node2D


signal menu_pause()
signal game_ended()

const MAX_PLAYERS = Globals.MAX_PLAYERS

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
	
	for enemy in enemies:
		enemy.remove_from_game()


func _process(_delta):
	## show "pause menu" overlay when esc key is pressed
	if Input.is_action_just_pressed("ui_cancel") and self.visible:
		emit_signal("menu_pause")


## called by both host and clients
func init_game(players):
	## reset values (from last game)
	spawn_positions = []
	enemies_alive = []
	actors = []
	
	## init amount actual enemies equals amount real other players
	for i in Globals.current_player_amount - 1:
		enemies_alive.append(enemies[i])
	
	actors.append(player)
	actors.append_array(enemies_alive)
	
	player.enemies = enemies_alive
	
	## give player his own id and then enemies the other players' ids
	actors[0].id = Globals.player_id
	for i in Globals.current_player_amount - 1:
		actors[i + 1].id = players[i]
	
	## init list spawn_positions
	var sp = map.get_node("SpawnPositions")
	for i in sp.get_child_count():
		spawn_positions.append(sp.get_child(i))


## (as host) start new game from scratch
func start_game(): #TODO add map param
	## assign every tank a random spawn_position
	var spawn_order = []
	for i in range(0, spawn_positions.size()):
		spawn_order.append(i)
	
	randomize()
	spawn_order.shuffle()
	
	for i in actors.size():
		actors[i].position = spawn_positions[spawn_order[i]].position
		actors[i].visible = true


## (as client) start game with existing players etc.
func load_game(player_infos):
	var enemy_iterator = 0
	for p in player_infos:
		if p == Globals.player_id:
			player.position = player_infos.get(p)
			player.visible = true
		else:
			enemies[enemy_iterator].position = player_infos.get(p)
			enemies[enemy_iterator].visible = true
			enemy_iterator += 1


func end_game():
	for actor in actors:
		actor.remove_from_game()
	
	## remove all still existing projectiles when game ends
	get_tree().call_group("game_generated", "queue_free")


func get_player_infos():
	var player_infos = {}
	
	for actor in actors:
		player_infos[actor.id] = actor.position
	
	return player_infos


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
	p.add_to_group("game_generated")
	
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
		emit_signal("game_ended")


func _on_TimerCooldown_timeout():
	player_can_shoot = true
