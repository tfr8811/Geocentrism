extends Sprite2D
@export var tracked: Node2D
var center
var padding = Vector2(100,100)
func _ready() -> void:
	center = get_viewport_rect().size/2
func _process(delta: float) -> void:
	rotation = position.angle()-PI/2
	position = Vector2(0,0)
	check_edges()
	if (is_tracked_in_bounds()):
		self.hide()
	else:
		self.show()
func check_edges():
	if (global_position.x > get_viewport_rect().size.x-padding.x):
		global_position.x = get_viewport_rect().size.x-padding.x
	elif (global_position.x < padding.x):
		global_position.x = padding.x
	if (global_position.y > get_viewport_rect().size.y-padding.y):
		global_position.y = get_viewport_rect().size.y-padding.y
	elif (global_position.y < padding.y):
		global_position.y = padding.y
func is_tracked_in_bounds():
	var inBounds = true
	if (tracked.global_position.x > get_viewport_rect().size.x):
		inBounds = false
	elif (tracked.global_position.x < 0):
		inBounds = false
	if (tracked.global_position.y > get_viewport_rect().size.y):
		inBounds = false
	elif (tracked.global_position.y < 0):
		inBounds = false
	return inBounds
