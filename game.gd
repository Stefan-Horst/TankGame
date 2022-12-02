extends Node2D

func _on_Player_shoot_projectile(Projectile, location, direction):
	var p = Projectile.instance()
	add_child(p)
	p.position = location
	p.rotation = direction
	p.velocity = p.velocity.rotated(direction)

