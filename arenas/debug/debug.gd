# DEBUG ARENA
#extends Node
extends Arena

var info = preload("res://scenes/Info/Info.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# set cam up
	Set_Camera_Up()
	for i in 1:
		# create genric game flow process
		#var GameFlow = MK_Process.new()
		#var gamflow_thread = MKPROC.Create_Thread(Equates.proc_id.pid_master, GameFlow, Global.TimeKeeper(GameFlow))
		
		# create fighter object
		var MyFighter = Fighter.new()
		MyFighter.Setup_Fighter(0)
		
		# create process and thread
		var myproc = MK_Process.new()
		var thread = MKPROC.Create_Thread(i, myproc, myproc.Human_Control)
		
		# add ref to obj in process
		myproc.myobj = MyFighter
		# add ref to thread in process
		myproc.mythread = thread
		
		# add fighter and process to global
		Global.Fighters.append(MyFighter)
		Global.Controllers.append(myproc)
		
		# moving sprite to a central location
		#MyFighter.Move_Object(Global.WINDOW_SIZE[0] / 2 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		MyFighter.Move_Object(i*100 + 150 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		#12# MyFighter.Move_Object(30*i+30 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		#MyFighter.Move_Object(24*i , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		
		# finally making it appear on screen
		Add_Object(MyFighter, $Layer_Fighters)
		
		#test on single thread so we can BP!
		# spoiler alert, doesn't work...
		#myproc.Human_Control()

###################### TESTING DEBUG INFO WINDOW ###############################
#	get_viewport().gui_embed_subwindows = false
#	var w = info.instantiate()
#	w.size = Vector2(400,800)
#	w.title="Fighter Info"
#	w.position=Vector2(4700, 420)
#	add_child(w)
################################################################################

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print camera stuff
	#print($Camera2D.global_position.x)
	#$Camera2D.global_position.x += 1
	
	#if Global.Fighters.size() > 0:
	#	$Camera2D.move_local_x(Global.Fighters[0].global_position.x)
	
	#print(Global.objs.size())
	$GodotSprite.rotate(delta)

func Set_Camera_Up():
	#self.add_child(cam1)
	$Camera2D.make_current()
	$Camera2D.limit_left = Left_Boundary
	$Camera2D.limit_right = Right_Boundary + Global.WINDOW_SIZE.x
