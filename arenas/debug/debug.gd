# DEBUG ARENA
#extends Node
extends Arena

var info = preload("res://scenes/Info/Info.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# set cam up
	Set_Camera_Up()
	
	# set some basic arena vars up
	Global.CurrentArena = self
	
	# create genric game flow process
	#var GameFlow = MK_Process.new()
	#var gamflow_thread = MKPROC.Create_Thread(Equates.proc_id.pid_master, GameFlow, Global.TimeKeeper(GameFlow))
	
	############## MAKE 1ST FIGHTER ############################################
	
	var MyFighter1 = Fighter.new(0)	# create fighter object
	var MyProc1 = MK_Process.new(0)	# create process and thread
	MyProc1.myobj = MyFighter1		# add ref to obj in process
	MyFighter1.myproc = MyProc1
	MyProc1.p_ganiy = MyFighter1.oyval	# set animation ground point
	MyFighter1.oxval = 0
	Add_Object(MyFighter1, $Layer_Fighters)		# finally making it appear on screen
	add_child(MyProc1)	# add this class to tree
	
	############## MAKE 2ND FIGHTER ############################################
	
#	var MyFighter2 = Fighter.new(0)
#	MyFighter2.scale.x = -1
#	var MyProc2 = MK_Process.new(1)
#	MyProc2.myobj = MyFighter2
#	MyFighter2.myproc = MyProc2
#	MyProc2.p_ganiy = MyFighter2.oyval
#	MyFighter2.oxval = 100
#	Add_Object(MyFighter2, $Layer_Fighters)
#	add_child(MyProc2)
	
	############## ASSOCIATE THE FIGHTERS ######################################
	
#	MyProc1.p_otherproc = MyProc2
#	MyProc1.p_otherguy = MyFighter2
#	MyProc2.p_otherproc = MyProc1
#	MyProc2.p_otherguy = MyFighter1

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
	
	# stick cam to player
	$Camera2D.position.x = Global.procs[0].myobj.oxval - 150
	$Layer_Font.position.x = $Camera2D.position.x
	Global.ticks +=1
	

func Set_Camera_Up():
	#self.add_child(cam1)
	$Camera2D.make_current()
	$Camera2D.limit_left = Left_Boundary
	$Camera2D.limit_right = Right_Boundary + Global.WINDOW_SIZE.x
	
