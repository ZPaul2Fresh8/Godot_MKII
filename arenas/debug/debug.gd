# DEBUG ARENA
#extends Node
extends Arena

var info = preload("res://scenes/Info/Info.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# set cam up
	Set_Camera_Up()
	for i in Equates.fighters.size() - 5:
		# create fighter object
		var MyFighter = Fighter.new()
		MyFighter.Setup_Fighter(i)
		
		# create process and thread
		var myproc = MK_Process.new()
		var thread = MKPROC.Create_Thread(i, myproc, myproc.Go_Idle)
		
		# add ref to obj in process
		myproc.myobj = MyFighter
		# add ref to thread in process
		myproc.mythread = thread
		
		# add fighter and process to global
		Global.Fighters.append(MyFighter)
		Global.Controllers.append(myproc)
		
		# moving sprite to a central location
		#MyFighter.Move_Object(Global.WINDOW_SIZE[0] / 2 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		MyFighter.Move_Object(30*i+30 , Global.WINDOW_SIZE[1] - Ground - MyFighter.Resources.Ground_Offset)
		
		# finally making it appear on screen
		Add_Object(MyFighter, $Layer_6)
		
###################### TESTING DEBUG INFO WINDOW ###############################
	get_viewport().gui_embed_subwindows = false
	var w = info.instantiate()
	w.size = Vector2(400,800)
	w.title="Fighter Info"
	w.position=Vector2(4700, 420)
	add_child(w)
################################################################################

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
