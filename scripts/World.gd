extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	$ButtonMainMenu.pressed.connect(_mainmenu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _mainmenu():
	get_tree().change_scene_to_file("res://scenes/StartUp.tscn")
