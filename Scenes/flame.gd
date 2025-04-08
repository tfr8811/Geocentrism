extends AnimatedSprite2D
var rng = RandomNumberGenerator.new()
var delayTime
func _ready() -> void:
	delayTime = rng.randf()*0.3
func _process(delta: float) -> void:
	delayTime -= delta
	if (!is_playing() && delayTime <= 0):
		play("explode")

func _on_animation_finished() -> void:
	queue_free()
