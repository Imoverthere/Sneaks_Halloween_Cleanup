extends Sprite2D

@onready var interaction_area: Area2D = $GoalArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func _ready() -> void:
	# Start locked by default
	if interaction_area:
		interaction_area.monitoring = false
	modulate.a = 0.4 # Slightly faded out to show it's locked
	
	# Check immediately in case a level starts with 0 destructibles
	check_pumpkins()

# REMOVED _process() completely to save CPU performance and prevent animation stuttering!

func check_pumpkins() -> void:
	# Look for "Destructible" nodes remaining in the scene
	var remaining_pumpkins = get_tree().get_nodes_in_group("Destructible")
	
	if remaining_pumpkins.size() == 0 and not is_open:
		open_goal()

func open_goal() -> void:
	is_open = true
	modulate.a = 1.0 # Bring to full structural visibility
	
	# Play the opening animation
	if animation_player and animation_player.has_animation("Open"):
		animation_player.play("Open")
		
	# Enable the physics collision so the player can now enter it
	if interaction_area:
		interaction_area.monitoring = true

func _on_goal_area_area_entered(area: Area2D) -> void:
	# FIX: Check if the incoming area belongs to the PlayerController
	if area.get_parent() is PlayerController:
		GameManager.win()
		print("Level Complete!")
		# GameManager.load_next_level() or win screen trigger
