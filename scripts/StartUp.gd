extends Node

# DEBUG VARS
@export var ShowFramesPerSecond : bool = false

# INTERLEAVED FILES
const PROGRAM_FILE = "res://assets/mk2.program"
const GRAPHICS_FILE = "res://assets/mk2.graphics"
const SOUNDS_FILE = "res://assets/mk2.sounds"


# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = Global.FRAME_RATE
	var w = $".".get_window()
	w.title = Global.GAME_TITLE + " - " + Global.REVISION
	
	#  IF ASSETS MISSING, SHOW EXTRACTION MSG
	if FileAccess.file_exists(PROGRAM_FILE) && FileAccess.file_exists(GRAPHICS_FILE) && FileAccess.file_exists(SOUNDS_FILE):
		$NoticePanel.visible = false	

	else:
		$NoticePanel.visible = true
	
	Debug_Test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Show FPS Option
	if ShowFramesPerSecond:
		$FPS_Label.visible = true
		$FPS_Label.text = str(Engine.get_frames_per_second())
	else:
		$FPS_Label.visible = false

func _buttonpressed():
	get_tree().get_root().propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _on_ok_button_pressed():
	# NOT UPDATING IN UI FSR
	$NoticePanel/Notice.text="Extracting Assets Be Patient."
	$NoticePanel/Notice/OK_Button.disabled = true
	
	var thread = Thread.new()
	thread.start(LoadAssets.CreateFiles)
	thread.wait_to_finish()
	
	_on_find_gfxbtn_pressed()

	$NoticePanel/Notice.text="Finished extracting assets."
	$NoticePanel/Notice/OK_Button.disabled = false
	$NoticePanel/Notice/OK_Button.text = "OK"
	$NoticePanel/Notice/OK_Button.pressed.connect(Debug_Test)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func Debug_Test():
	# Extract.Fonts()
	# Extract.Animations()
	
	# TEST ANIMATIONS HERE
	get_tree().change_scene_to_file("res://arenas/debug/debug.tscn")
	
	#var image = Tools.Draw_Image(0x658d6, true) #  - copyright 1-bit
	#var image = Tools.Draw_Image(0x4f1b4) #  - lifebar
	#var image = Tools.Draw_Image(0x64692) # - Raiden Works
	#var image = Tools.Draw_Image(0x4f41a) # - VS - Compression

func _on_find_gfxbtn_pressed():
	#var thread = Thread.new()
	#thread.start(LoadAssets.Find_Img_Headers)
	LoadAssets.Find_Img_Headers()
