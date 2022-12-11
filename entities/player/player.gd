extends Actor

signal player_destroyed()

# value 0 makes tank steer in same direction no matter if it is going forwards or backwards
# value 1 makes it steer in opposite direction when going backwards
var backwards_steering_mode = 0
# init by game.gd
var enemies = []


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
		emit_signal("shoot_projectile", Projectile, self, projectile_pos.global_position, turret_rotation)


func _on_entity_hit(projectile_emitter, hit_entity):
	if hit_entity.name == self.name and projectile_emitter in enemies:
		## move dead player out of map
		remove_from_game()
		
		emit_signal("player_destroyed")
