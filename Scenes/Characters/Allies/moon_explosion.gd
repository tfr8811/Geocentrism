extends AnimatedSprite2D
@export
var earth = false
func _ready() -> void:
	play()
func _on_animation_finished() -> void:
	if (earth):
		if (GlobalWorldState.Score > GlobalWorldState.GatekeeperScore):
			get_tree().change_scene_to_file("res://Scenes/UI/NameEntry.tscn")
		else:
			get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")
	queue_free()
