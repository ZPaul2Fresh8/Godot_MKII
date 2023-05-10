extends Node
class_name Equates

# EQUATES
const FIGHTER_COUNT = 0x10

var fighter_names = [ 
	"Kung Lao",
	"Liu Kang",
	"Cage",
	"Baraka",
	"Kitana",
	"Mileena",
	"Shang Tsung",
	"Raiden",
	"Sub-Zero",
	"Reptile",
	"Scorpion",
	"Jax",
	"Kintaro",
	"Shao Kahn",
	"Smoke",
	"Noob Saibot",
	"Jade" ]

enum fighters {
		KUNG_LAO,
		LIU_KANG,
		CAGE,
		BARAKA,
		KITANA,
		MILEENA,
		SHANG_TSUNG,
		RAIDEN,
		SUBZERO,
		REPTILE,
		SCORPION,
		JAX,
		KINTARO,
		SHAO_KAHN,
		SMOKE,
		NOOB_SAIBOT,
		JADE }

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

enum obj_ids {
	oid_blood = proc_id.pid_blood,
	oid_lightning = proc_id.pid_lightning,
	oid_p1 = proc_id.pid_p1,
	oid_p2 = proc_id.pid_p2,
	oid_fx = proc_id.pid_fx,		# special f/x
	oid_head = proc_id.pid_head,
	oid_grow = proc_id.pid_grow,
	oid_bones = proc_id.pid_bones,
	oid_1_puff = proc_id.pid_1_puff,

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

enum game_state {
	gs_amode = 0x1,			# game is in attract mode
	gs_fighting = 0x2,		
	gs_buyin = 0x3,			
	gs_psel = 0x4,			# fighter select mode
	gs_bonus = 0x5,			# bonus count state
	gs_pfsetup = 0x6,		# pre-fight setup state
	gs_round_intro = 0x7,	# round intro
	gs_diag = 0x8,			# game is in diagnostics/audits/adjustments
	gs_pitfall = 0x9,		# fallin down the pit
	gs_initials = 0xa,		# enter initials
	gs_gameover = 0xb,		# game over
	gs_octopus = 0xc,		# octopus mode
	gs_post_psel = 0xd,		# post player select mode
	gs_barge = 0xe,			# player barging in mode
	gs_sec_intro = 0xf		# intro secret
	}

enum char_id {
	Kung_Lao,
	Liu_Kang,
	Cage,
	Baraka,
	Kitana,
	Mileena,
	Shang_Tsung,
	Raiden,
	SubZero,
	Reptile,
	Scorpion,
	Jax,
	Kintaro,
	Shao_Kahn,
	Smoke,
	Noob_Saibot,
	Jade }

enum actions {
	# Projectile Attacks
	Act_Throw_Hat = 0x1,
	Act_Lkzap_Lo = 0x2,
	Act_Lkzap_Hi = 0x3,
	Act_Lkzap_Air = 0x4,
	Act_Jcsnot_Lo = 0x5,
	Act_Jcsnot_Hi = 0x6,
	Act_Spark = 0x7,
	Act_Throw_Fans = 0x8,
	Act_Air_Fans = 0x9,
	Act_Throw_Tsai = 0xa,
	Act_Air_Tsai = 0xb,
	Act_Throw_Skull1 = 0xc,
	Act_Throw_Skull2 = 0xd,
	Act_Throw_Skull3 = 0xe,
	Act_Throw_Bolt = 0xf,
	Act_Throw_Ice = 0x10,
	Act_Spear = 0x11,
	Act_Spit = 0x12,
	Act_Slow_Orb = 0x13,
	Act_Jax_Zap = 0x14,

	# Stationary Attacks
	Act_Attacks = 0x100,
	Act_Hipunch = 0x101,
	Act_Lopunch = 0x102,
	Act_Hikick = 0x103,
	Act_Medkick = 0x104,
	Act_Rhouse = 0x105,
	Act_Sweep = 0x106,
	Act_Uppercut = 0x107,
	Act_Hhspin = 0x108,
	Act_Backbreak = 0x109,
	Act_Splits = 0x10a,
	Act_Jupkick = 0x10e,
	Act_Knee = 0x10f,
	Act_Duck_Kickh = 0x113,
	Act_Elbow = 0x114,
	Act_Juppunch = 0x118,
	Act_Duckpunch = 0x119,
	Act_Duck_Kickl = 0x11a,
	Act_2nd_Knee = 0x11c,
	Act_Shred = 0x11d,
	Act_Swipe = 0x11e,
	Act_Fan_Swipe = 0x120,
	Act_Sa_Spin = 0x121,
	Act_Noogy = 0x122,
	Act_Sonic = 0x12c,
	Act_Floor_Ice = 0x134,
	Act_Quake = 0x137,

	# Body Propelling Attacks
	Act_Body_Propell = 0x200,
	Act_Flykick = 0x200,
	Act_Flypunch = 0x201,
	Act_Hh_Teleport = 0x202,
	Act_Superkang = 0x203,
	Act_Bike = 0x204,
	Act_Shadk = 0x205,
	Act_Shoruken = 0x206,
	Act_Square = 0x207,
	Act_Fntele = 0x208,
	Act_Dive = 0x209,
	Act_Decoy = 0x20a,
	Act_Scissor = 0x20b,
	Act_Slide = 0x20c,
	Act_Reptile_Fly = 0x20d,
	Act_Kano = 0x20e,

	# Non-Attacking Actions
	Act_Nonattacks = 0x300,
	Act_Backup = 0x301,
	Act_Duck = 0x302,
	Act_Stance = 0x303,
	Act_Land = 0x304,
	Act_Walkf = 0x305,
	Act_Postattack = 0x306,
	Act_Walkb = 0x307,
	Act_Angle_Jump = 0x308,
	Act_Melt = 0x309,
	Act_Getup = 0x30a,
	Act_Jumpup = 0x30b,

	# Specific Actions
	Act_Stunned = 0x400,
	Act_Frozen = 0x401,
	Act_Speared = 0x402,
	Act_Shocker = 0x403,
	Act_Morph = 0x404,
	Act_Rope_Pull = 0x405,
	Act_Balled = 0x406,
	Act_Psycho_Goro = 0x407,
	Act_Pre_Shatter = 0x408,
	Act_Hat_Killer = 0x409,

	# Unrelated Actions
	Act_Proj_Dead = 0x500,
	Act_Ignore_Proj = 0x501,
	Act_Dead = 0x502,
	Act_Reacting = 0x503,
	Act_Gflip = 0x504,
	Act_Burning = 0x505,
	Act_Pit_Fall = 0x506,
	Act_Bodyslam = 0x507,
	Act_Spike_Rise = 0x508,
	Act_Wait_Pud = 0x509,
	Act_Slime_Fall = 0x50a,
	Act_Proj_Passed = 0x50b,

	# Sitting Duck States
	Act_Sweep_Sd = 0x600,
	Act_Knee_Sd = 0x601,
	Act_Dive_Sd = 0x602,
	Act_Upcut_Sd = 0x603,
	Act_Proj_Sd = 0x604,
	Act_Speared_Sd = 0x605,
	Act_Upcutted = 0x606,
	Act_Decoy_Sd = 0x607,
	Act_Shadow_Sd = 0x608,
	Act_Hitfall_Sd = 0x609,
	Act_Slide_Sd = 0x60a,
	Act_Elbow_Sd = 0x60b,
	Act_Ret_Kick = 0x60c,
	Act_Fk_Sd = 0x60d,
	Act_Slipping = 0x60e,
	Act_Spin_Sd = 0x60f,
	Act_Jax_Dizzy = 0x610,
	Act_Shoruken_Sd = 0x611,
	Act_Fntele_Sd = 0x612,
	Act_Shock_Sd = 0x613,
	Act_Wave_Sd = 0x614,
	Act_Shocker_Sd = 0x615,
	Act_Super_Froze = 0x616,
	Act_Superk_Sd = 0x617,
	Act_Skull_Sd = 0x618,
	Act_Kano_Sd = 0x619,
	Act_Hh_Sd = 0x61a,
	Act_Orb_Sd = 0x61b,

	# Blocks
	Act_Blocks = 0x700,
	Act_Blockhi = 0x700,
	Act_Blockl = 0x701 }

var ani_names = [
	"STANCE",
	"WALK_FWD",
	"SKIP_FWD",
	"WALK_BWD",
	"SKIP_BWD",
	"DUCK",
	"JUMP_UP",
	"FLIP_FORWARD",
	"FLIP_BACKWARD",
	"TURN_AROUND",
	"TURN_AROUND_CROUCHED",
	"BLOCKING",
	"BLOCKING_CROUCHED",
	"HIGH_KICK",
	"LOW_KICK",
	"KNOCKED_DOWN",
	"HIT_HIGH",
	"HIT_LOW",
	"NORMAL_GET_UP",
	"HIGH_PUNCH",
	"LOW_PUNCH",
	"SWEEPING",
	"SWEPT",
	"GET_UP_FROM_SWEPT",
	"LOW_PUNCH_CROUCHED",
	"HIGH_KICK_CROUCHED",
	"LOW_KICK_CROUCHED",
	"TAKING_HIT_CROUCHED",
	"UPPERCUT",
	"JUMP_UP_KICK",
	"FLYING_KICK",
	"FLYING_PUNCH",
	"ROUND_HOUSE",
	"KNEE_TO_MID_SECTION",
	"ELBOW_TO_FACE",
	"STUMBLE_BACKWARDS",
	"GRAB_OPPONENT_TO_THROW",
	"SHREDDED",
	"THROW_PROJECTILE",
	"PROJECTILE_OBJECT",
	"STUNNED",
	"VICTORY_POSE",
	"THROWN_BY_LAO",
	"THROWN_BY_KANG",
	"THROWN_BY_CAGE",
	"THROWN_BY_BARAKA",
	"THROWN_BY_KITANA",
	"THROWN_BY_MILEENA",
	"THROWN_BY_SHANG",
	"THROWN_BY_RAIDEN",
	"THROWN_BY_SUBZERO",
	"THROWN_BY_REPTILE",
	"THROWN_BY_SCORPION",
	"THROWN_BY_JAX",
	"LOW_BLOWED",
	"BICYCLE_KICKED",
	"SOUL_DRAINED",
	"TORSO_GETTING_RIPPED",
	"SLOW_PROJ_BANG",
	"GETTING_IMPALED",
	"FALLING_FROM_DECAPITATION",
	"DECAPITATED_HEAD_ROTATING",
	"THROWN_BY_KITARO",
	"BACK_BREAKER",
	"CHANGE",
	"SCORPION_SLICED_ME"]

enum ani_ids {
	STANCE,
	WALK_FWD,
	SKIP_FWD,
	WALK_BWD,
	SKIP_BWD,
	DUCK,
	JUMP_UP,
	FLIP_FORWARD,
	FLIP_BACKWARD,
	TURN_AROUND,
	TURN_AROUND_CROUCHED,
	BLOCKING,
	BLOCKING_CROUCHED,
	HIGH_KICK,
	LOW_KICK,
	KNOCKED_DOWN,
	HIT_HIGH,
	HIT_LOW,
	NORMAL_GET_UP,
	HIGH_PUNCH,
	LOW_PUNCH,
	SWEEPING,
	SWEPT,
	GET_UP_FROM_SWEPT,
	LOW_PUNCH_CROUCHED,
	HIGH_KICK_CROUCHED,
	LOW_KICK_CROUCHED,
	TAKING_HIT_CROUCHED,
	UPPERCUT,
	JUMP_UP_KICK,
	FLYING_KICK,
	FLYING_PUNCH,
	ROUND_HOUSE,
	KNEE_TO_MID_SECTION,
	ELBOW_TO_FACE,
	STUMBLE_BACKWARDS,
	GRAB_OPPONENT_TO_THROW,
	SHREDDED,
	THROW_PROJECTILE,
	PROJECTILE_OBJECT,
	STUNNED,
	VICTORY_POSE,
	THROWN_BY_LAO,
	THROWN_BY_KANG,
	THROWN_BY_CAGE,
	THROWN_BY_BARAKA,
	THROWN_BY_KITANA,
	THROWN_BY_MILEENA,
	THROWN_BY_SHANG,
	THROWN_BY_RAIDEN,
	THROWN_BY_SUBZERO,
	THROWN_BY_REPTILE,
	THROWN_BY_SCORPION,
	THROWN_BY_JAX,
	LOW_BLOWED,
	BICYCLE_KICKED,
	SOUL_DRAINED,
	TORSO_GETTING_RIPPED,
	SLOW_PROJ_BANG,
	GETTING_IMPALED,
	FALLING_FROM_DECAPITATION,
	DECAPITATED_HEAD_ROTATING,
	THROWN_BY_KITARO,
	BACK_BREAKER,
	CHANGE,
	SCORPION_SLICED_ME }
