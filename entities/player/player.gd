extends KinematicBody2D

#value 0 makes tank steer in same direction no matter if it is going forwards or backwards
#value 1 makes it steer in opposite direction when going backwards
var backwards_steering_mode = 0
var speed = 200
var angular_speed = 1

func _process(delta):
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
