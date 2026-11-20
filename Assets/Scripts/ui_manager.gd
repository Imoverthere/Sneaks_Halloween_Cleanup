extends CanvasLayer


func _ready() -> void:
	$CoinDisplay.text = str(GameManager.total_coins)
	
	GameManager.gained_coins.connect(update_coin_display)
	GameManager.pause_menu = $PauseMenu
	GameManager.win_screen = $WinScreen
	GameManager.score_label = $WinScreen/Label

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_play()
		get_tree().paused = GameManager.paused

func update_coin_display(gained_coins):
	$CoinDisplay.text = str(GameManager.total_coins)

func _on_resume_pressed() -> void:
	GameManager.resume()

func _on_restart_pressed() -> void:
	GameManager.restart()
	GameManager.resume()

func _on_world_map_pressed() -> void:
	GameManager.load_world()

func _on_quit_pressed() -> void:
	GameManager.quit()


func _on_continue_pressed() -> void:
	GameManager.load_world()
