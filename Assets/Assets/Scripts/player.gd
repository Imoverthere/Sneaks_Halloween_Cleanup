extends CharacterBody2D
class_name PlayerController


@export var speed = 10.0
@export var acceleration: float = 600
@export var jump_power = 10.0
@export var friction: float = 800


var speed_mult = 30.0
var jump_mult = -30.0
var direction = 0

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power * jump_mult

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("move left", "move right")
	
	# Target velocity based on input
	var target_speed: float = direction * speed * speed_mult
	
	if direction:
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()


func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		area.take_damage()
