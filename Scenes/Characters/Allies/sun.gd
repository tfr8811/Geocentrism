extends Area2D
var mass = 40
@export var raySprite: Sprite2D
@export var faceAnim: AnimatedSprite2D
var faceFreeze = 0.0
var flameDelay = 0.0
var rng = RandomNumberGenerator.new()
var velocity = Vector2(0, 0)
var flame = preload("res://Scenes/Effects/Flame.tscn")
func _ready() -> void:
	position = GlobalWorldState.sunStartPosition
func _process(delta: float) -> void:
	raySprite.rotate(delta)
	if (faceFreeze > 0):
		faceFreeze -= delta
	if (flameDelay > 0):
		flameDelay -= delta
func _physics_process(delta: float) -> void:
	if (is_instance_valid(GlobalWorldState.Player)):
		var player = GlobalWorldState.Player
		var force = player.global_position - global_position
		var distance = force.length()
		if distance > 600:
			# when sun is really far away it will come back a bit faster
			distance = 400
			if faceFreeze <= 0:
				faceAnim.set_animation("worried")
		elif distance < 170:
			distance = 170
			if faceFreeze <= 0:
				faceAnim.set_animation("worried")
		else:
			if faceFreeze <= 0:
				faceAnim.set_animation("default")
		# assuming G = 30000 and the masses are equal
		var strength = 30000*mass*mass / (distance * distance);
		force = force.normalized()
		force *= strength
		apply_force(force)
		position += velocity * delta
		for object in get_overlapping_bodies():
			if object.is_in_group("Damageable"):
				if flameDelay <= 0:
					spawn_flames(object)
					flameDelay = 0.3
				object.take_damage()
				# this one takes priority
				if  !faceAnim.get_animation() == "oh_shit" \
					&& !faceAnim.get_animation() == "celebration1" \
					&& !faceAnim.get_animation() == "celebration2" \
					&& !faceAnim.get_animation() == "celebration3":
					var randomValue = rng.randf()
					if (randomValue < 0.33):
						faceAnim.set_animation("celebration1")
					elif (randomValue > 0.67):
						faceAnim.set_animation("celebration2")
					else:
						faceAnim.set_animation("celebration3")
					faceFreeze = 1.0
		check_edges()
func apply_force(force: Vector2) -> void:
	# acceleration = force / mass
	# add acceleration to velocity
	velocity += force/mass
func check_edges():
	if (position.x > get_viewport_rect().size.x):
		position.x = get_viewport_rect().size.x
		velocity.x *= 0
	elif (position.x < 0):
		position.x = 0
		velocity.x *= 0
	if (position.y > get_viewport_rect().size.y):
		position.y = get_viewport_rect().size.y
		velocity.y *= 0
	elif (position.y < 0):
		position.y = 0
		velocity.y *= 0
func spawn_flames(body: CharacterBody2D):
	for i in range (0,5):
		var iflame = flame.instantiate()
		body.add_child(iflame)
		iflame.position += Vector2(rng.randf_range(-100,100), rng.randf_range(-100,100))

func _on_ray_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") && faceFreeze <= 0:
		faceAnim.set_animation("grrr")
		faceFreeze = 1.0
		
func oh_shit():
	faceAnim.set_animation("oh_shit")
	faceFreeze = 1.0
