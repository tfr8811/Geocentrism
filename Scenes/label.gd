extends Label
func _physics_process(delta: float) -> void:
	self.text = str(GlobalWorldState.Score)
