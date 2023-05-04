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

#pdata
var plink									# 0x000 - link ot next table - stored in proc array
var procid : int							# 0x020 - process id
var ptime : int								# 0x030 - sleep time
var psptr									# 0x040 - process stack pointer
var pa11									# 0x060 - register a11 save
var pa10									# 0x080 - register a10 save
var pa9										# 0x0a0 - register a9 save
var pa8										# 0x0c0 - register a8 save
var pwake									# 0x0e0 - proces to run on wake?

# process storage							# 0x100
var p_joyport								# joystick port location
var p_butport								# button port
var p_otherguy : Object_Resource			# other guys object
var p_otheract : int						# other guys last action
var p_otherproc : Process_Resource			# other guys process
var p_slave : Object_Resource				# slave object
var p_anitab								# current animation table
var p_anirate : int							# animation speed
var p_anicount : int						# animation counter
var p_action : int							# current action
var p_ganiy : int							# ground animation point y
var p_flags									# more flags (see p_flag_bits)
var p_downcount : int						# ticks i have been ducking
var p_store1								# long word storage 1
var p_store2								# long word storage 2
var p_store3								# long word storage 3
var p_store4								# long word storage 4
var p_store5								# long word storage 5
var p_store6								# long word storage 6
var p_store7								# long word storage 7
var p_store8								# long word storage 8
var p_dronevar1								# drone variable 1
var p_stk									# strike table i am using
var p_hitby : int							# i was hit by this last
var p_hit : int								# hit count

enum p_flag_bits {
	pm_joy = 0,			# flag: i am a joystick controlled guy
	pm_finish = 1,		# flag: i get to finish other player off!
	pm_reacting = 2,	# flag: i am reacting to some attack
	pm_sitduck = 3,		# flag: i am a sitting duck
	pm_special = 4,		# flag: i am doing a special move (no doubles)
	pm_alt_pal = 5,		# flag: i am using an alternate palette !!
	pm_corpse = 6,		# flag: i am a wasted drone corpse
	pm_emperor = 7,		# flag: i am the emperor
	pm_gninja = 8		# flag: i am the green ninja
}
