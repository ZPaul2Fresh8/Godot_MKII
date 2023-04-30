extends Resource
class_name Process_Resource

# PROCESS STRUCTURE

enum proc_id {
	pid_george = 0,				# G to the N to the P

	# constant running procs
	pid_p1	 = 0x1,				# player 1 process (be careful if these
	pid_p2	 = 0x2,				# player 2 process  variables are changed)
	pid_master = 0x3,			# master game flow process
	pid_scroll = 0x4,			# scroll process
	pid_backg = 0x5,			# background process
	pid_bani = 0x6,				# background object animator
	pid_repell = 0x7,			# repell players proc
	pid_lightning = 0x8,		# raiden lightning accompany
	pid_flasher = 0x9,			# player message flasher
	pid_p1sel = 0xa,			# 1 select process
	pid_p2sel = 0xb,			# 2 select process
	pid_cred = 0xc ,			# credits proc
	pid_initials = 0xd,			# initials proc
	pid_amode = 0xe,			# mode process
	pid_cycle = 0xf,			# cycler
	pid_oct	 = 0x10,			#
	pid_inviso1 = 0x11,			# 1 inviso proc
	pid_inviso2 = 0x12,			# 2 inviso proc
	pid_floor_ice1 = 0x13,		# ice proc p1 
	pid_floor_ice2 = 0x14,		# ice proc p2
	pid_super_slam = 0x15,		# super slam scanning proc
	pid_danger1 = 0x16,			# player 1 danger proc
	pid_danger2 = 0x17,			# player 2 danger proc
	pid_smoker = 0x18,			# proc to constantly smoke a dude
	pid_1_puff = 0x19,			# 1 puff o smoke
	pid_pong_speed = 0x1a,		# pong speed up
	pid_green_splash = 0x1b,	#
	pid_auto_cycle = 0x1c,		# auto select color cycler

	# 100 = special effects procs
	pid_fx = 0x100,				# generic special f/x
	pid_fade = 0x101,			# fade proc
	pid_grow = 0x102,			# fx grower proc
	pid_shaker = 0x103,			# earth shaker proc
	pid_trail = 0x104,			# body trail (shadow kick)
	pid_decoy = 0x105,			# scorpion decoy proc
	pid_jc_shadow1 = 0x106,		# cage shadow "borrow" proc for player 1
	pid_jc_shadow2 = 0x107,		# cage shadow "borrow" proc for player 2
	pid_selspeech = 0x108,		# player select speech proc
	pid_mpo = 0x109,			# multipart object process
	pid_melt = 0x10a,			# raiden melt decoy animator proc
	pid_hhdecoy = 0x10b,		# hathead decoy
	pid_bones = 0x10c,			#
	pid_poof = 0x10d,			# reptile poof proc
	pid_sonic = 0x10e,			# sonic wave proc
	pid_forden = 0x10f,			# forden peeker

	# 200 = procs which control prop objects
	pid_blood = 0x201,			# blood spirts
	pid_head = 0x202,			# decapped head


	# 300 = switch spawned procs
	pid_switch1 = 0x300,		# switch spawned process !!
	pid_switch2 = 0x301,		# switch spawned process !!

	# 700 = player 1 projectile procs
	pid_proj1 = 0x700,			# generic projectile !!
	pid_hat1 = 0x701,			# kung lao hat proc #1
	pid_orb1 = 0x702,			# reptile orb
	pid_ice1 = 0x703,			# ice proc #1

	# 800 = player 2 projectile procs
	pid_proj2 = 0x800,			# generic projectile !!
	pid_hat2 = 0x801,			# kung lao hat proc #2
	pid_orb2 = 0x802,			# reptile orb
	pid_ice2 = 0x803,			# ice proc #2

	pid_volume = 0x7000,

	# 8000 = coin switch pids
	pid_lc = 0x8c00,			# left coin	
	pid_cc = 0x8c02,			# center coin	
	pid_rc = 0x8c04,			# right coin	
	pid_xc = 0x8c06,			# fourth coin slot
	pid_slam = 0x8c08,	 		# slam tilt process
	pid_coinctr = 0x8c0a,		# coin counter process
	pid_print = 0x800c,			# background printer process
	pid_diag = 0x800d,			# diagnostics process
	pid_secbust = 0x800e		# sec bust proc
}

var sleep_time : int

#pdata
var jostick_switch_port_location
var button_port
var other_guys_object : Object_Resource
var other_guys_last_action
var other_guys_process : Process_Resource
var slave_object : Object_Resource
var current_animation_table
var animation_speed : float
var animation_counter : int
var current_action : int
var grounded_animation_point_y : int
var more_flags
var ticks_i_have_been_ducking : int
var long_word_storage_1
var long_word_storage_2
var long_word_storage_3
var long_word_storage_4
var long_word_storage_5
var long_word_storage_6
var long_word_storage_7
var long_word_storage_8
var drone_variable_1
var strike_table_i_am_using
var i_was_hit_by : int
