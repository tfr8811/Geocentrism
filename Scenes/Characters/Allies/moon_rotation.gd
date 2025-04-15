extends Node2D
@export var speedupZone: Area2D
func _physics_process(delta: float) -> void:
	if (speedupZone.has_overlapping_bodies()):
		var distanceToClosestBody = 300.0
		for body in speedupZone.get_overlapping_bodies():
			var distanceToBody = body.global_position-global_position
			if (distanceToBody.length() < distanceToClosestBody):
				distanceToClosestBody = distanceToBody.length()
		self.rotate(delta*(1+(300 - distanceToClosestBody)/300)/2)
	self.rotate(delta*2)
