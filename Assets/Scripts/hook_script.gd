extends RigidBody2D

signal stuck_to_wall(anchor_position)

@onready var ray_cast = $RayCast2D
@onready var tip_marker = $TipMarker

var is_stuck = false

func _physics_process(_delta):
	if is_stuck:
		return

	#if ray_cast.is_colliding():
		#stick_to_surface()

func stick_to_surface():
	is_stuck = true
	
	var collision_point = ray_cast.get_collision_point()
	
	freeze = true
	process_mode = PROCESS_MODE_DISABLED 
	
	var tip_offset = global_position - tip_marker.global_position
	global_position = collision_point + tip_offset
	
	# Emit the signal so the player knows they can start pulling
	stuck_to_wall.emit(global_position)
