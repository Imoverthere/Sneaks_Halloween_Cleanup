extends Node

signal gained_coins(int)
signal level_beaten()

var coins : int = 0
var score : int = 0
var current_checkpoint : Checkpoint
var pause_menu
var win_screen
var score_label

var player: PlayerController
var damage_taken = 0

var paused = false

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

func gain_coins(coins_gained:int):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)

func win():
	emit_signal("level_beaten")
	win_screen.visible = true
	score_label.text = "score:" + str(score)
func pause_play():
	paused = !paused
	
	pause_menu.visible = paused
	

func resume():
	get_tree().paused = false
	pause_play()
	
func restart():
	score = 0
	get_tree().reload_current_scene()
	
func load_world():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://world_map.tscn")
	
func quit():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.close(); window.location.href = 'about:blank';")
	else:
		get_tree().quit()
