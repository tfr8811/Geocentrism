extends CharacterBody2D
var speed = 100
var health = 1
var dead = false
var invincibility = 0.0
var launchTime = 0.0
@export var sprite: AnimatedSprite2D
@export var bloodAuraSprite: AnimatedSprite2D
@export var hitbox: CollisionShape2D
func _ready() -> void:
	bloodAuraSprite.play()
func _process(delta: float) -> void:
	if launchTime > 0.0: launchTime -= delta
func _physics_process(delta: float) -> void:
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
func launch(direction: Vector2):
	velocity = direction * speed * 5
	launchTime = 0.25


func _on_animated_sprite_2d_animation_finished() -> void:
	if dead: queue_free()
