#extends Sprite2D
extends AnimatedSprite2D
class_name MK_Object

# debug options
@export_category("Debug")
@export var Print_Location : bool

# OBJECT STRUCTURE
var olink						# 0x000 - link to next object in pool (not used, now in Global Array)
var ograv						# 0x020 - gravity
var oxvel						# 0x040 - x vel
var oyvel						# 0x060 - y vel
var oxval : int					# 0x080 - x position
var oyval : int					# 0x0a0 - y position
var ozval : int					# 0x0c0 - z index
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
	# add obj to pool
	Global.objs.append(self)

func _process(delta):
	if Print_Location:
		print(self.get_transform().origin)

func Move_Object(X : int, Y : int):
	self.move_local_x(X)
	self.move_local_y(Y)
