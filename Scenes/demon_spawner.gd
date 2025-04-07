extends Node2D
var basic_bitch = load("res://Scenes/Demon.tscn")
var big_bitch = load("res://Scenes/BigBitch.tscn")
var distance = 500
var counter = 3
var limit = 3;
var rng = RandomNumberGenerator.new()
func _physics_process(delta: float) -> void:
	var instance
	if counter >= limit:
		if (GlobalWorldState.Score >= 3 && rng.randf() > 0.8):
			instance = big_bitch.instantiate()
		else:
			instance = basic_bitch.instantiate()
		add_child(instance)
		var spawnPos = Vector2.RIGHT
		spawnPos = spawnPos.rotated(randf_range(0, TAU))
		spawnPos *= 1000
		spawnPos += get_viewport_rect().size/2
		instance.position = spawnPos
		counter = 0
		limit -= delta
	if limit < 0.01:
		limit = 0.01
	counter += delta
