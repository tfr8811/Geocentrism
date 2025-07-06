extends Area2D
@export var moon: Node2D
@export var rainbow: Sprite2D
var moonExplosion = preload("res://Scenes/Characters/Allies/MoonExplosion.tscn")
var earthExplosion = preload("res://Scenes/Characters/Allies/EarthExplosion.tscn")
var freeze = 0.0
func _ready() -> void:
	GlobalWorldState.Player = self
	position = get_global_mouse_position()
	GlobalWorldState.Score = 0 
func _process(delta: float) -> void:
	if freeze > 0.0: freeze -= delta
func _physics_process(delta: float) -> void:
	if freeze > 0:
		return
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
	hitstun()
	# pause for effect
	Engine.time_scale = 0.005  # Adjust for desired freeze intensity
	await get_tree().create_timer(0.008).timeout
	Engine.time_scale = 1.0  # Resume normal speed
	# earth explosion
	var iEarthExplostion = earthExplosion.instantiate()
	get_parent().add_child(iEarthExplostion)
	iEarthExplostion.global_position = global_position
	queue_free()

func hitstun():
	freeze = 0.5

func _on_body_entered(body: Node2D) -> void:
	body.hitstun()
	take_damage()


func _on_moon_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var direction = body.global_position - self.global_position
		direction = direction.normalized()
		body.launch(direction)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sun"):
		# sun reaction
		area.oh_shit()
		area.hitstun()
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
