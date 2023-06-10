extends Sprite2D
class_name MK_Object

# debug options
@export_category("Debug")
@export var Print_Location : bool
var myproc : MK_Process
var Segments : Array[Sprite2D]

enum FacingDirection {
	Right,
	Left
}

# OBJECT STRUCTURE
var olink						# 0x000 - link to next object in pool (not used, now in Global Array)
var ograv : float = 0				# 0x020 - gravity
var oxvel : float = 0				# 0x040 - x vel
var oyvel : float = 0				# 0x060 - y vel
var oxval : float = 0				# 0x080 - x position
var oyval : float = 0				# 0x0a0 - y position
var ozval : int = 0					# 0x0c0 - z index
var ofset						# 0x0e0 - bits 16-31 precomputed offset
var oflags						# 0x0f0 - bits 0-5 dma control
var osag						# 0x100 - sprite data address
var osizex						# 0x120 - x size
var osizey						# 0x130 - y size
var opal						# 0x140 - palette index

#var oflags2					# 0x160 - game flags (see underneath)
var no_scroll : bool			# don't scroll this object
var multipart : bool			# multipart object
var noblock : bool				# player can't block at this moment
var noflip : bool				# i can't be flipped at this moment
var shadow : bool				# shadow me
var palette : int				# palette

var oscale						# 0x180 - scale factor for dma
var oimg						# 0x1a0 - pointer to image header
var oid : int					# 0x1c0 - object id
var oshape						# 0x1d0 - multipart "ani shape"
var ochar : int					# 0x1f0 - char id

func _init():
	#print("Object says hi")
	# add obj to pool
	Global.objs.append(self)

func _process(delta):
	# 0.0188679245283 = Delta
	
	# make gravity work
	oyvel = oyvel + ograv
	
	# make vertical placement
	#oyval = oyval + (oyvel / 0x10000) # + (ograv / 0x10000)
	oyval = oyval + oyvel # + (ograv / 0x10000)
	position.y = oyval
	
	# make horizontal placement
	oxval = oxval + (oxvel/0x10000)
	position.x = oxval

	$"../../Layer_Font/DebugContainer/X".text = "X: " + str(oxval)
	$"../../Layer_Font/DebugContainer/Y".text = "Y: " + str(oyval)
	if myproc != null:
		$"../../Layer_Font/DebugContainer/state".text = "State: " + myproc.states.keys()[myproc.mystate]
		#$"../../Layer_Font/DebugContainer/state".text = "Action: " + str(Equates.actions.keys().
	$"../../Layer_Font/DebugContainer/xvel".text = "X Velocity: " + str(oxvel)
	$"../../Layer_Font/DebugContainer/yvel".text = "Y Velocity: " + str(oyvel)
	$"../../Layer_Font/DebugContainer/oid".text = "Object ID: " + str(ochar)
	$"../../Layer_Font/DebugContainer/grav".text = "Gravity: " + str(ograv)

func Move_Object(X : int, Y : int):
	self.move_local_x(X)
	self.move_local_y(Y)
