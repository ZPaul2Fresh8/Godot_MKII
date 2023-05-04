extends Resource
class_name Object_Resource

# OBJECT IDS
enum obj_ids {
	oid_blood = Process_Resource.proc_id.pid_blood,
	oid_lightning = Process_Resource.proc_id.pid_lightning,
	oid_p1 = Process_Resource.proc_id.pid_p1,
	oid_p2 = Process_Resource.proc_id.pid_p2,
	oid_fx = Process_Resource.proc_id.pid_fx,		# special f/x
	oid_head = Process_Resource.proc_id.pid_head,
	oid_grow = Process_Resource.proc_id.pid_grow,
	oid_bones = Process_Resource.proc_id.pid_bones,
	oid_1_puff = Process_Resource.proc_id.pid_1_puff,

	# when adding more proc's for projectiles make sure you update
	# wait_for_prj routine

	# 700 = projectiles
	oid_hat1 = 0x700,			# hathead projectile
	oid_fireball = 0x701,		# kang projectile
	oid_snot = 0x702,			# cage projectile
	oid_snot_trail1 = 0x703,	#
	oid_snot_trail2 = 0x704,	#
	oid_fans1 = 0x705,			# player 1 fans
	oid_fans2 = 0x706,			# player 2 fans
	oid_sai1 = 0x707,
	oid_sai2 = 0x708,
	oid_slow_proj = 0x709,		# slow reptile projectile
	oid_hat2 = 0x70a,			# hathead projectile

	# 800 = non-game related
	oid_cbox = 0x800,			# collision box
	oid_text = 0x801,
	oid_cursor1 = 0x802,		# player 1 select cursor
	oid_cursor2 = 0x803,		# player 2 select cursor
	oid_buyin = 0x804,			# buyin object
	oid_symbol = 0x805			# bonus count symbol
}

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
var oflags2						# 0x160 - game flags
var oscale						# 0x180 - scale factor for dma
var oimg						# 0x1a0 - pointer to image header
var oid : int					# 0x1c0 - object id
var oshape						# 0x1d0 - multipart "ani shape"
var ochar : int					# 0x1f0 - char id
