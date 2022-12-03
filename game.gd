extends Node2D

var player_can_shoot = true

onready var cooldown_timer = $Player/TimerCooldown

func _on_Player_shoot_projectile(Projectile, location, direction):
	if player_can_shoot:
		player_can_shoot = false
		
		var p = Projectile.instance()
		add_child(p)
		
		p.position = location
		p.rotation = direction
		p.velocity = p.velocity.rotated(direction)
		
		cooldown_timer.wait_time = p.cooldown
		cooldown_timer.start()

func _on_TimerCooldown_timeout():
	player_can_shoot = true
