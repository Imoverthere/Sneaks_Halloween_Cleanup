extends Node2D


@onready var level_holder = $LevelHolder
@onready var player = $Player

var levels = []
@onready var curr_level = $LevelHolder/Level1

var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1

func _ready():
	player.get_node("AnimationPlayer").play("idle")
	levels = level_holder.get_children()
	update_levels()
	
func update_levels():
	for level in levels:
		if level.name in LevelData.level_dic:
			if LevelData.level_dic[level.name]["unlocked"] == true:
				level.get_node("Locked").texture = load("res://Assets/Assets/Sprites/unlocked.png")
			if LevelData.level_dic[level.name]["beaten"] == true:
				level.get_node("Locked").texture = load("res://Assets/Assets/Sprites/beaten.png")
		else:
			level.get_node("Locked").texture = load("res://Assets/Assets/Sprites/locked.png")
			
			
func _process(delta):
	var target_level : Node2D
	
	if Input.is_action_just_pressed("up"):
		if curr_level.up:
			target_level = curr_level.up
	if Input.is_action_just_pressed("down"):
		if curr_level.down:
			target_level = curr_level.down
	if Input.is_action_just_pressed("left"):
		if curr_level.left:
			target_level = curr_level.left
	if Input.is_action_just_pressed("right"):
		if curr_level.right:
			target_level = curr_level.right

	if Input.is_action_just_pressed("jump"):
		player.get_node("AnimationPlayer").play("Select")
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://" + curr_level.name + ".tscn")
		
