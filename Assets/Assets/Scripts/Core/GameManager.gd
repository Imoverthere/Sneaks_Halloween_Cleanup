extends Node

var current_checkpoint : Checkpoint



var player: PlayerController
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
