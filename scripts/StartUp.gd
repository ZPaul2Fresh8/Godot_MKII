extends Node

# DEBUG VARS
@export var ShowFramesPerSecond : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = Global.FRAME_RATE
	$RichTextLabelM.text = Global.REVISION
	$GridContainer/Menu/Button_LoadWorld.pressed.connect(_loadworld)
	$GridContainer/Menu/Button_Quit.pressed.connect(_buttonpressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Show FPS Option
	if ShowFramesPerSecond:
		$FPS_Label.visible = true
		$FPS_Label.text = str(Engine.get_frames_per_second())
	else:
		$FPS_Label.visible = false
	
	# Show Revision
	$RichTextLabelM.text = Global.REVISION


func _loadworld():
	print("World loaded")
	get_tree().change_scene_to_file("res://scenes/Attract.tscn")


func _buttonpressed():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
