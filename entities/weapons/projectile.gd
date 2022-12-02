extends KinematicBody2D

var max_amount_bounces = 1 # value of 0 disables wallbounces
var speed = 10
var amount_bounces = 0
var velocity = Vector2.UP.rotated(rotation) * speed

func _physics_process(_delta):
	var collision = move_and_collide(velocity)
	if collision:
		## reflect projectiles that hit walls
		velocity = velocity.bounce(collision.normal)
		print(rad2deg(velocity.angle()))
		## determine rotation of reflected projectile
		"""# one way to measure direction: left = 0, right = pi, top = 0.5pi, bottom = -0.5pi
		var col = collision.normal.angle()
		var angle
		if col > 0.25*PI and col < 0.75*PI: # top quarter circle 
			angle = PI + rotation
		elif col < -0.25*PI and col > -0.75*PI: # bottom quarter circle 
			angle = rotation - PI
		else:
			angle = rotation
		rotation = 2*PI - angle"""
		# velocity.angle rotated 90 degrees
		rotation = velocity.angle() + 0.5*PI
		amount_bounces += 1
	
	if amount_bounces == max_amount_bounces + 1:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
