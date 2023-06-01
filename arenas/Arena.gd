extends Node2D
class_name Arena

@export_category("Arena Properties")

@export_subgroup("Basic")
@export var Name : String
@export var Round_Time : int
@export var Unlimited_Time : bool
@export var Left_Boundary : int = 123456
@export var Right_Boundary : int
@export var Ground : int

@export_subgroup("Music")

@export_subgroup("Layer 0")
@export var Horizontal_Start_0 : int
@export var Vertical_Start_0 : int
@export var Parallax_Value_0 : int

var cam = Camera2D.new()
var Layer_0 = Panel.new()

func _init():
	Global.ground_y = Ground

func _ready():
	#Set_Camera_Up()
	pass

# can't inherit var cam from arena scripts fsr?
#func Set_Camera_Up():
#	self.add_child(cam)
#	cam.enabled = true
#	cam.make_current()
#	cam.limit_left = Left_Boundary
#	cam.limit_right = Right_Boundary + Global.WINDOW_SIZE.x
#	cam.offset.x = 200
#	cam.offset.y = 127
#	cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER

static func Add_Object (Obj : Object, Layer : Panel):
	Layer.add_child(Obj)

static func Remove_Object (Obj : Object, Layer : Panel):
	Layer.remove_child(Obj)
