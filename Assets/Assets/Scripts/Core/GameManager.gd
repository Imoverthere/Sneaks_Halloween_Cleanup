extends Node

var current_checkpoint : Checkpoint
var player: PlayerController

# Define a fallback position in case no checkpoints are active or flagged as spawnpoints
@export var default_spawn_position : Vector2 = Vector2.ZERO

func respawn_player():
	# Safety check to ensure the player reference exists before moving it
	if player == null:
		push_error("GameManager: Cannot respawn because player reference is missing!")
		return
	player.health = player.max_health
	
	if current_checkpoint != null:
		player.global_position = current_checkpoint.global_position
	else:
		# Fallback to the default level position if no checkpoints are available
		player.global_position = default_spawn_position
