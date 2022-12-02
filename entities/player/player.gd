extends KinematicBody2D

signal shoot_projectile(projectile, location, direction)

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
	## player movement
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
	if Input.is_action_pressed("ui_down"):
		velocity = -Vector2.UP.rotated(rotation) * speed
		if backwards_steering_mode == 0:
			direction *= -1
	
	# moves the player and causes them to slide along walls
	move_and_slide(velocity) #warning-ignore:RETURN_VALUE_DISCARDED

	rotation += angular_speed * direction * delta

	## player turret rotation
	turret.look_at(get_global_mouse_position())
	turret.rotation_degrees += 90 #either this fix or rotate sprite image
	
	## player combat
	if Input.is_action_just_pressed("ui_select"):
		var turret_rotation = turret.rotation + rotation
		emit_signal("shoot_projectile", Projectile, projectile_pos.global_position, turret_rotation)
