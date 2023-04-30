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

var obj_id : int
var obj_oflags
var img_header
var img_source
var pos_x : int
var pos_y : int
var pos_z : int
var vel_x
var vel_y
var gravity
var size_x
var size_y
var pal_index
var draw_attirbute
var scale_y
var scale_x
var multipart_sprite
var char_id = Equates.char_id
