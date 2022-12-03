extends KinematicBody2D

var max_amount_bounces = 1 # value of 0 disables wallbounces
var speed = 10
var cooldown = 1 # gun cooldown in seconds
var amount_bounces = 0
var velocity = Vector2.UP.rotated(rotation) * speed

func _physics_process(_delta):
	var collision = move_and_collide(velocity)
	if collision:
		
		# Collision of projectile with other KinematicBody2D instance
		# TODO: collision of 2 projectiles? Maybe change enemy to layer 3?
		if collision.collider.get_class() == "KinematicBody2D":
			# TODO: use Signals instead?
			collision.collider._on_Npc_destroyed()
			queue_free()
		
		## reflect projectiles that hit walls
		velocity = velocity.bounce(collision.normal)
		
		## determine rotation of reflected projectile
		# velocity.angle rotated 90 degrees
		rotation = velocity.angle() + 0.5*PI
		amount_bounces += 1
		
	if amount_bounces == max_amount_bounces + 1:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
