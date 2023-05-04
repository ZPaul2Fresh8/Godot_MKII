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
		
		# temp reload
		Global.program = FileAccess.get_file_as_bytes(PROGRAM_FILE)
		Global.graphic = FileAccess.get_file_as_bytes(GRAPHICS_FILE)
		Global.sound = FileAccess.get_file_as_bytes(SOUNDS_FILE)
		
		reset_game()

	else:
		$NoticePanel.visible = true


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
	$NoticePanel/Notice/OK_Button.pressed.connect(reset_game)


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()


func reset_game():
	# check for test menu
	get_tree().change_scene_to_file("res://scenes/Attract.tscn")


func _on_find_gfxbtn_pressed():
	#var thread = Thread.new()
	#thread.start(LoadAssets.Find_Img_Headers)
	LoadAssets.Find_Img_Headers()
	
