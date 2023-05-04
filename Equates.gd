extends Node
class_name Equates

# EQUATES

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
