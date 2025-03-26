extends CharacterBody2D
var mass = 20
func _physics_process(delta: float) -> void:
	if (is_instance_valid(GlobalWorldState.Player)):
		var player = GlobalWorldState.Player
		var force = player.global_position - global_position
		var distance = force.length()
		# assuming G = 10000 and the masses are equal
		var strength = 10000*mass*mass / (distance * distance);
		force = force.normalized()
		force *= strength
		apply_force(force)
		var collision = move_and_collide(velocity * delta)
		if collision:
			var object = collision.get_collider()
			if object.is_in_group("Damageable"):
				object.take_damage()
func apply_force(force: Vector2) -> void:
	# acceleration = force / mass
	# add acceleration to velocity
	velocity += force/mass
