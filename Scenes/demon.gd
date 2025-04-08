extends CharacterBody2D
var speed = 200
var dead = false
var launchTime = 0.0
@export var eyeSprite: AnimatedSprite2D
@export var fleshSprite: AnimatedSprite2D
@export var bloodAuraSprite: AnimatedSprite2D
@export var hitbox: CollisionShape2D
func _ready() -> void:
	bloodAuraSprite.play()
func _process(delta: float) -> void:
	if !dead: fleshSprite.rotate(-delta)
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
func take_damage():
	if !dead:
		dead = true
		GlobalWorldState.Score += 1
		fleshSprite.modulate = Color(1, 0, 0)
		fleshSprite.play("death")
		eyeSprite.queue_free()
		bloodAuraSprite.queue_free()
		hitbox.disabled = true

func launch(direction: Vector2):
	velocity = direction * speed * 5
	launchTime = 0.25


func _on_flesh_anim_animation_finished() -> void:
	if dead: queue_free()
