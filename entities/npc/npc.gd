extends KinematicBody2D

signal shoot_projectile(projectile, location, direction)
signal destroyed()

# value 0 makes tank steer in same direction no matter if it is going forwards or backwards
# value 1 makes it steer in opposite direction when going backwards
var backwards_steering_mode = 0
var speed = 200
var angular_speed = 1

var Projectile = preload("res://entities/weapons/projectile.tscn")

onready var turret = $SpriteTurret
onready var projectile_pos = turret.get_node("SpriteGun/PosProjectile")

# _physics_process is computed in fixed intervals, which is required for accurate
# computation of move_and_slide()
func _physics_process(delta):
	pass


func _on_Npc_destroyed():
	print("Hit!")
	queue_free()
