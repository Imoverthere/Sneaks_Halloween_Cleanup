extends Control

@onready var menu_boxes: VBoxContainer = $MenuBoxes
@onready var options_menu: Panel = $"Options Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_boxes.visible = true
	options_menu.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Level1.tscn")


func _on_options_pressed() -> void:
	print("Options")
	menu_boxes.visible = false
	options_menu.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_return_pressed() -> void:
	menu_boxes.visible = true
	options_menu.visible = false
