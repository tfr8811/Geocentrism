extends Control
@export var sun: Area2D
@export var earth: Sprite2D
var sunVec
func _ready() -> void:
	sunVec = earth.position - sun.global_position
func _physics_process(delta: float) -> void:
	sunVec = sunVec.rotated(-delta)
	sun.position = earth.position - sunVec
func _on_begineth_pressed() -> void:
	GlobalWorldState.sunStartPosition = sun.global_position
	get_tree().change_scene_to_file("res://Scenes/Levels/Level.tscn")
