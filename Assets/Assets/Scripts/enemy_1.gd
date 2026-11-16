extends CharacterBody2D
class_name Knight

var speed = 30
var facing_right = true
var dead = false

@export var score = 100

func _ready():
	$AnimationPlayer.play("Move")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# flip the enemy if it reaches a wall or edge
	if !$EdgeDetection.is_colliding() && is_on_floor():
		flip()
		
	velocity.x = speed
	move_and_slide()
	
	if is_on_wall() and is_on_floor():
		flip()
	
	# CONTINUOUS CHECK: Catch a stationary player if the entry signal missed
	for area in $Hitbox.get_overlapping_areas():
		check_and_damage_player(area)

func flip():
	facing_right = !facing_right
	
	# Flip the speed direction
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
		
	# Flip the visuals instead of the parent scale.x
	$Sprite2D.flip_h = !facing_right
	
	# Manually flip the Edge & Wall Detectors position so it stays in front of the enemy
	$EdgeDetection.position.x = abs($EdgeDetection.position.x) * (1 if facing_right else -1)
	
	
	# Manually flip the Hitbox Area2D position if it has an offset
	$Hitbox.position.x = abs($Hitbox.position.x) * (1 if facing_right else -1)

# Extracted logic to use for both the signal and the continuous check
func check_and_damage_player(area: Area2D) -> void:
	if area.get_parent() is PlayerController && !dead:
		area.get_parent().take_damage(1)

func _on_hitbox_area_entered(area: Area2D) -> void:
	check_and_damage_player(area)
	
func die():
	GameManager.score += score
	dead = true
	speed = 0
	$AnimationPlayer.play("Die")
	
