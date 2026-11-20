extends Node2D
class_name Coin

@export var score = 10
@export var coins = 1
var collected := false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if collected:
		return
	if area.get_parent() is PlayerController:
		collected = true
		GameManager.gain_coins(coins)
		GameManager.score += score
		queue_free()
