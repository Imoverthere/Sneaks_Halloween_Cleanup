extends Node

signal gained_coins(total_coins: int) # Emit total_coins so UI stays synced
signal level_beaten()

var total_coins : int = 0 # Persists across all levels
var coins : int = 0       # Tracks coins collected in the current level
var score : int = 0
var current_checkpoint : Checkpoint
var pause_menu
var win_screen
var score_label
var can_double_jump : bool = false

var player: PlayerController
var damage_taken = 0
var enemies_beaten = 0
var paused = false

@export var default_spawn_position : Vector2 = Vector2.ZERO

func respawn_player():
	if player == null:
		push_error("GameManager: Cannot respawn because player reference is missing!")
		return
	player.health = player.max_health
	
	if current_checkpoint != null:
		player.global_position = current_checkpoint.global_position
	else:
		player.global_position = default_spawn_position

func gain_coins(coins_gained: int):
	coins += coins_gained
	total_coins += coins_gained
	gained_coins.emit(total_coins)

func win():
	emit_signal("level_beaten")
	win_screen.visible = true
	score_label.text = "score:" + str(score)

func restart():
	# Subtract unbanked level coins on restart so players can't farm coins
	total_coins -= coins
	coins = 0
	score = 0
	damage_taken = 0
	enemies_beaten = 0
	current_checkpoint = null
	get_tree().reload_current_scene()

func load_world():
	# Reset per-level stats when returning to the world map (total_coins stays!)
	coins = 0
	score = 0
	damage_taken = 0
	enemies_beaten = 0
	current_checkpoint = null
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scripts/world_map.tscn")

func pause_play():
	paused = !paused
	pause_menu.visible = paused

func resume():
	get_tree().paused = false
	pause_play()

func quit():
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.close(); window.location.href = 'about:blank';")
	else:
		get_tree().quit()
