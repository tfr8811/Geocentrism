extends CharacterBody2D
var speed = 100
var health = 1
var dead = false
var invincibility = 0.0
var launchTime = 0.0
var freeze = 0.0
# this caps combo depth to prevent the glitch
var launchDepth = 0
@export var sprite: AnimatedSprite2D
@export var bloodAuraSprite: AnimatedSprite2D
@export var hitbox: CollisionShape2D
func _ready() -> void:
	bloodAuraSprite.play()
func _process(delta: float) -> void:
	if launchTime > 0.0: launchTime -= delta
	if freeze > 0.0: freeze -= delta
func _physics_process(delta: float) -> void:
	if freeze > 0:
		return
	# death handler
	if dead:
		# keep momentum
		move_and_slide()
		return
	if (is_instance_valid(GlobalWorldState.Player)):
		var player = GlobalWorldState.Player
		var direction = player.global_position - global_position
		direction = direction.normalized()
		if launchTime <= 0: velocity = lerp(velocity, direction * speed, delta * 5.0)
		move_and_slide()
		if launchTime > 0:
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var body = collision.get_collider()
				if body.is_in_group("Enemy") && !body.is_launching() && launchDepth < 5:
					var directionForLaunch = body.global_position - self.global_position
					directionForLaunch = directionForLaunch.normalized()
					body.launchDepth = launchDepth + 1
					# multiply that velocity by 2 cuz a big bitch packs a punch
					body.launch2(directionForLaunch, velocity.length()*2)
	# reduce invincibility, this prevents double hits
	if invincibility > 0:
		invincibility -= delta
func take_damage():
	if invincibility > 0 || dead:
		return
	elif health > 0:
		health -= 1
		invincibility = 1.0
		sprite.play("low_health")
	else:
		dead = true
		GlobalWorldState.Score += 1
		sprite.modulate = Color(1, 0, 0)
		sprite.play("death")
		bloodAuraSprite.queue_free()
		hitbox.disabled = true
func hitstun():
	freeze = 0.5
func launch(direction: Vector2):
	launchDepth = 1;
	GlobalWorldState.Score += 1
	velocity = direction * speed * 5
	launchTime = 0.25

func launch2(direction: Vector2, power: float):
	GlobalWorldState.Score += 1
	# big bitch is heavy so the power gets divided by 2
	velocity = direction * power/2
	launchTime = 0.25

func is_launching():
	if launchTime > 0:
		return true
	return false


func _on_animated_sprite_2d_animation_finished() -> void:
	if dead: queue_free()
