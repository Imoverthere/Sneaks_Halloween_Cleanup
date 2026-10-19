extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

func activate():
	GameManager.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("Activated")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerController && !activated:
		activate()
