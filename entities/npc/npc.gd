extends Actor

#signal destroyed()

# _physics_process is computed in fixed intervals, which is required for accurate
# computation of move_and_slide()
func _physics_process(delta):
	pass


func _on_entity_hit(projectile_emitter, hit_entity):
	if hit_entity.name == self.name and projectile_emitter == "player":
		queue_free()
