extends KinematicBody2D

#value 0 makes tank steer in same direction no matter if it is going forwards or backwards
#value 1 makes it steer in opposite direction when going backwards
var backwards_steering_mode = 0
var speed = 200
var angular_speed = 1

onready var turret = $SpriteTurret

func _process(delta):
	# player movement
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

	rotation += angular_speed * direction * delta
	position += velocity * delta
	
	# player turret alway point at cursor
	turret.look_at(get_global_mouse_position())
	turret.rotation_degrees += 90 #either this fix or rotate sprite image
