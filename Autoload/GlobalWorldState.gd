extends Node
var Player
var Score = 0
var GatekeeperScore = 0;
var sunStartPosition = Vector2(180, 460)
var LeaderboardInitialBoot = true
func _ready() -> void:
  SilentWolf.configure({
	"api_key": "yi407VWkf749q4yl3R6XHaXkyCFYDtx3YFonh554",
	"game_id": "geocentrism",
	"log_level": 1
  })

  SilentWolf.configure_scores({
	"open_scene_on_close": "res://Scenes/UI/Titlescreen.tscn"
  })
