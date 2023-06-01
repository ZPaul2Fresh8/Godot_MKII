# DEBUG ARENA
#extends Node
extends Arena

# Called when the node enters the scene tree for the first time.
func _ready():
	# set cam up
	Set_Camera_Up()
	
	# create fighter object
	var MyFighter = Fighter.new()
	MyFighter.Setup_Fighter(Equates.fighters.REPTILE)
	
	# create process and thread
	var MyProc = MK_Process.new()
	var thread = MKPROC.Create_Thread(1, MyProc, MyProc.Go_Idle)
	
	
	# add ref to obj in process
	MyProc.myobj = MyFighter
	# add ref to thread in process
	MyProc.mythread = thread
	
	# add fighter and process to global
	Global.Fighters.append(MyFighter)
	Global.Controllers.append(MyProc)
	
	# moving sprite to a location
	MyFighter.Move_Object(Global.WINDOW_SIZE[0] / 2 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
	
	# This util uses a global ground variable which takes a sec to initialize from the arena's resources
	#MKUTIL.Ground_Object(MyFighter)	
	
	# finally making it appear on screen
	self.Add_Object(MyFighter, $Layer_6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print camera stuff
	#print($Camera2D.global_position.x)
	#$Camera2D.global_position.x += 1
	#$Camera2D.look_at(Global.p1_obj.position)
	#print(Global.objs.size())
	$Sprite2D.rotate(delta)
	pass

func Set_Camera_Up():
	#self.add_child(cam1)
	$Camera2D.make_current()
	$Camera2D.limit_left = Left_Boundary
	$Camera2D.limit_right = Right_Boundary + Global.WINDOW_SIZE.x
