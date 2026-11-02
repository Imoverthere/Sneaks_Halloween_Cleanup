extends Node2D

@export var player_controller : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D


func _ready() -> void:
	# Connect the signal so we know exactly when the attack ends
	if animation_player:
		animation_player.animation_finished.connect(_on_animation_finished)


func _process(delta):
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
