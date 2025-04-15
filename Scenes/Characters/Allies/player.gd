extends Area2D
var dead = false
@export var moon: Node2D
@export var rainbow: Sprite2D
var moonExplosion = preload("res://Scenes/Characters/Allies/MoonExplosion.tscn")
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
	GlobalWorldState.Score = 0
	get_tree().call_deferred("reload_current_scene")

func _on_body_entered(body: Node2D) -> void:
	take_damage()


func _on_moon_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var direction = body.global_position - self.global_position
		direction = direction.normalized()
		body.launch(direction)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sun"):
		take_damage()


func _on_moon_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sun"):
		# moon explosion
		var iMoonExplostion = moonExplosion.instantiate()
		get_parent().add_child(iMoonExplostion)
		var moon_global_position = moon.get_child(0).global_position
		iMoonExplostion.global_position = moon_global_position
		# moon removal
		moon.queue_free()
		rainbow.hide()
		# sun reaction
		area.oh_shit()
