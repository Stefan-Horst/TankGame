extends KinematicBody2D

signal entity_hit(projectile_emitter, hit_entity)

var max_amount_bounces = 1 # value of 0 disables wallbounces
var speed = 10
var cooldown = 1 # gun cooldown in seconds
var amount_bounces = 0
var emitter = "" # entity that shoots the projectile
var velocity = Vector2.UP.rotated(rotation) * speed

func _physics_process(_delta):
	var collision = move_and_collide(velocity)
	if collision:
		# Collision of projectile with other KinematicBody2D instance
		# TODO: collision of 2 projectiles? Maybe change enemy to layer 3?
		if collision.collider.get_class() == "KinematicBody2D":
			emit_signal("entity_hit", emitter, collision.collider)
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
