extends CharacterBody2D
var dead = false
func _ready() -> void:
	GlobalWorldState.Player = self
func _physics_process(delta: float) -> void:
	position = get_global_mouse_position()
	check_edges()
func check_edges():
	if (position.x > get_viewport_rect().size.x):
		position.x = get_viewport_rect().size.x
	elif (position.x < 0):
		position.x = 0
	if (position.y > get_viewport_rect().size.y):
		position.y = get_viewport_rect().size.y
	elif (position.y < 0):
		position.y = 0
func take_damage():
	dead = true
	self.queue_free()
