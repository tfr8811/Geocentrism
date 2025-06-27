extends Control
@onready var line_edit: LineEdit = $LineEdit
var player_name
func _on_submit_button_pressed() -> void:
	if line_edit.text != "":
		player_name = line_edit.text
		SilentWolf.Scores.save_score(player_name, GlobalWorldState.Score)
		get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")
