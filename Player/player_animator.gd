extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D


func _ready() -> void:
	# Connect the signal so we know exactly when the attack ends
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)


func _process(_delta):
#	flips the character sprite
	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
	#	While player is not attacking
	if not player_controller.attacking:
	#	plays move animation if moving, else idle
		if abs(player_controller.velocity.x) > 0.0:
			animation_player.play("move")
		else :
			animation_player.play("idle")
		# plays jump and fall animation
		if player_controller.velocity.y < 0.0:
			animation_player.play("jump")
		elif player_controller.velocity.y > 0.0:
			animation_player.play("fall")

	# 3. Reset the attacking flag when the attack animation stops playing
func _on_animation_finished(anim_name: StringName):
	if anim_name == "Attack": # Double check this matches your attack animation name exactly
		player_controller.attacking = false

func flash_iframes(duration: float):
	if not sprite:
		return
		
	# Create a tween that processes even if things shift frames
	var tween = create_tween().set_loops(5) # Loops 5 times total
	
	# Blink out (semi-transparent), then blink back in (solid) over 0.2 seconds per loop
	tween.tween_property(sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	
	# Safely force alpha back to 1.0 when the iframe period fully completes
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(sprite):
		sprite.modulate.a = 1.0
	
	
