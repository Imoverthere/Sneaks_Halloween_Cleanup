extends CharacterBody2D
class_name PlayerController


@export var speed = 10.0
@export var acceleration: float = 600
@export var jump_power = 10.0
@export var friction: float = 800
@export var attacking = false

var speed_mult = 30.0
var jump_mult = -30.0
var direction = 0
var max_health = 2
var health = 0
var can_take_damage = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		attack()

func _ready():
	health = max_health
	GameManager.player = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_mult

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move left", "move right")
	
#	Puts the hitbox of the hammer on the side where the player is facing
	if direction == -1:
		$PlayerAnimator/Sprite2D/SwordHit.scale.x = abs($Area2D.scale.x) * -1
	elif direction == 1:
		$PlayerAnimator/Sprite2D/SwordHit.scale.x = abs($Area2D.scale.x)
	
	# Target velocity based on input
	var target_speed: float = direction * speed * speed_mult
	
	if direction:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()
	
	if position.y >= 600:
		die()

func attack():
	attacking = true
	$PlayerAnimator.animation_player.play("Attack")
	
	var overlapping_objects = $PlayerAnimator/Sprite2D/SwordHit.get_overlapping_areas()
	
	for area in overlapping_objects:
		var parent = area.get_parent()
		
		# Check if the target is an enemy and has a die function
		if parent.has_method("die"):
			parent.die() # This triggers the enemy's script, animation, and queue_free!

	
	attacking = true
	$PlayerAnimator.animation_player.play("Attack")

func take_damage(damage_amount : int):
	if can_take_damage:
		iframes()
		
		health -= damage_amount
	
	if health <= 0:
		die()
		
func iframes():
	can_take_damage = false
	if has_node("PlayerAnimator"):
		$PlayerAnimator.flash_iframes(1.0)
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func die():
	GameManager.respawn_player()
	
func _input(event):
	if event.is_action_pressed("down") && is_on_floor():
		position.y += 3

func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.take_damage()
		
