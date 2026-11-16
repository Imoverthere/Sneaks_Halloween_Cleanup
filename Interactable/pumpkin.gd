extends Node2D
class_name Pumpkin

@export var score = 50

func die():
	GameManager.score += score
	remove_from_group("Destructible")
	
	# 2. Tell the goal node to check if all pumpkins are gone
	var goal = get_tree().get_first_node_in_group("goal")
	if goal and goal.has_method("check_pumpkins"):
		goal.check_pumpkins()
		
	queue_free()
