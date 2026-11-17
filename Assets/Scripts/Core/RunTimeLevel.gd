extends Node
class_name RunTimeLevel

@onready var level_name = name

var max_score = 0
var max_coins = 0
var max_enemies = 0

func _ready():
	GameManager.coins = 0
	GameManager.score = 0
	GameManager.damage_taken = 0
	GameManager.enemies_beaten = 0
	GameManager.level_beaten.connect(beat_level)
	set_values()
		

func set_values():
	for node in find_children("*", "", true, false):
		if node is Coin:
			max_score += node.score
			max_coins += node.coins
		if node is Knight or node is Pumpkin:
			max_score += node.score
		if node is Knight:
			max_enemies += 1
		if "Knight" in node.name or "Enemy" in node.name:
			print("Found enemy node: ", node.name, " | Script: ", node.get_script(), " | Is Knight: ", node is Knight)

func beat_level():
	LevelData.generate_level(LevelData.level_dic[level_name]["unlocks"])
	LevelData.level_dic[LevelData.level_dic[level_name]["unlocks"]]["unlocked"] = true

	LevelData.update_level(level_name, GameManager.score, max_score, GameManager.coins, max_coins, GameManager.enemies_beaten, max_enemies, GameManager.damage_taken, true)
