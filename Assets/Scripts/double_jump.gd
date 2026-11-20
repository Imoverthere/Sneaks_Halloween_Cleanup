extends Node2D

@export var required_coins: int = 20
@export var spend_coins: bool = false

func die() -> void:
	print("Hit Unlockable")
	if GameManager.can_double_jump:
		return

	if GameManager.total_coins >= required_coins:
		if spend_coins:
			GameManager.total_coins -= required_coins
			GameManager.gained_coins.emit(GameManager.total_coins)

		GameManager.can_double_jump = true
		print("Double jump unlocked!")
		queue_free() # Changed from get_parent().queue_free() so it only deletes Double_Jump!
	else:
		print("Locked! Need ", required_coins - GameManager.total_coins, " more coins.")
