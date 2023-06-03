extends Node

const GAME_TITLE : String = "Mortal Kombat II"
const REVISION : String = "Revision 3.1"
const FRAME_RATE : float = 53.20
const TICK_TIME : float = 1000 / FRAME_RATE # ~18.79ms per game tick
const WINDOW_SIZE : Vector2i = Vector2i(400, 254)
const PROGRAM_FILE = "res://assets/mk2.program"
const GRAPHICS_FILE = "res://assets/mk2.graphics"
const SOUNDS_FILE = "res://assets/mk2.sounds"

const Fighter_Resource_Paths : Array[String] = [
	"res://fighters/0_Kung_Lao.tres",
	"res://fighters/1_Liu_Kang.tres",
	"res://fighters/2_Cage.tres",
	"res://fighters/3_Baraka.tres",
	"res://fighters/4_Kitana.tres",
	"res://fighters/5_Mileena.tres",
	"res://fighters/6_Shang.tres",
	"res://fighters/7_Raiden.tres",
	"res://fighters/8_SubZero.tres",
	"res://fighters/9_Reptile.tres",
	"res://fighters/10_Scorpion.tres",
	"res://fighters/11_Jax.tres",
	"res://fighters/12_Kintaro.tres",
	"res://fighters/13_Kahn.tres",
	"res://fighters/14_Smoke.tres",
	"res://fighters/15_Noob.tres",
	"res://fighters/16_Jade.tres"]
const Arena_Resource_Paths : Array[String] = [
	"res://arenas/0_Dead_Pool.gd"
]
const Image_Path = "res://assets/images/"

# PROCESSES
var procs : Array[MK_Process]

# OBJECTS
var objs : Array[MK_Object]

# PALETTE
var pals : Array[PackedColorArray]

# GLOBAL VARIABLES: 
var program : PackedByteArray = FileAccess.get_file_as_bytes(PROGRAM_FILE)
var graphic : PackedByteArray = FileAccess.get_file_as_bytes(GRAPHICS_FILE)
var sound : PackedByteArray = FileAccess.get_file_as_bytes(SOUNDS_FILE)

# PLAYER OBJECTS
var Controllers : Array [MK_Process]
var Fighters : Array [Fighter]

# ARENA
var CurrentArena : Arena

# NOT USED YET
#var up_vel = 0xa000
#var up_grav = 0x8000
#var bb_fatality = 5
#var pit_fatality = 6
#var fs_fatality = 7
#var spike_fatality = 8
#var pong_battle_num = 250
#var close_to_edge = 68			# this constitutes being close to the edge
#var floor_ice_time = 60
#var full_strength = 0xa1
#var front_z = 050
#var back_z = 0x04
#var rand : int = 1		# rand,32,1
#var swstack : int	# switch stack	
#var swtemp1 : int
#var swtemp2 : int
#var swtemp3 : int
#var swtemp4 : int
#swstmn,256,1		# bottom of stack
#swstst,0,1		# start switch stack
#syscopy,16,1		# ram copy of sysctrl latch
#intsync1,16,1		# full screen interrupt synchro.
#palram,0,1		# palette allocator ram
#fpalram,palrsiz*nmfpal,1	
#bpalram,palrsiz*nmbpal,1	
#ptrram,ptrsiz*numptr,1
#nplayers,16,1		# max # of players allowed
#irqled,16,1
#pageaddr,32,1
#
# DISPLAY SYSTEM RAM
#
#start_of_dram,0,1
#irqskye,16,1		# actual sky color (autoerase)
#page,16,1
var ticks : int		# universal timer zeroed at round start
#noflip,16,1		# no page flipping needed
#displayon,16		# do display processing when != 0
#dlists,32,1		# display lists table
#call_every_tick,32,1	# call this routine every tick
#scrolly,32		# y scroll value
#worldtly,32		# top left y screen coord (world)
#scrollx8,32,1		# background #8 x scroll
#scrollx7,32,1		# background #7 x scroll
#scrollx6,32,1		# background #6 x scroll
#scrollx5,32,1		# background #5 x scroll
#scrollx4,32,1		# background #4 x scroll
#scrollx3,32,1		# background #3 x scroll
#scrollx2,32,1		# background #2 x scroll
#scrollx,32,1		# x scroll value
#scrollx0,32,1		# background #0 x scroll
#worldtlx8,32,1		# background #8 x world coord
#worldtlx7,32,1		# background #7 x world coord
#worldtlx6,32,1		# background #6 x world coord
#worldtlx5,32,1		# background #5 x world coord
#worldtlx4,32,1		# background #4 x world coord
#worldtlx3,32,1		# background #3 x world coord
#worldtlx2,32,1		# background #2 x world coord
#worldtlx,32,1		# top left x screen coord (world)
#worldtlx0,32,1		# background #0 x world coord
# OBJECT LISTS
#
#baklst8,32,1		# background list #8
#baklst7,32,1		# background list #7
#baklst6,32,1		# background list #6
#baklst5,32,1		# background list #5
#baklst4,32,1		# background list #4
#baklst3,32,1		# background list #3
#baklst2,32,1		# background list #2
#baklst1,32,1		# background list #1
#objlst,32,1			# player object list
#objlst2,32,1		# object list #2
#objlst3,32,1		# object list #3
#last_objlst,0,1
#score_area_ram,sns*30,1	# score area dma ram
#score_ram_end,0,1		# end of it !
#score_1st,32,1			# 1st dma entry for score area
#p1_shadadj,16,1			# player 1 shadow y adjustment !
#p2_shadadj,16,1			# player 2 shadow y adjustment !
#clk_tens,16,1			# clock tens digit
#clk_ones,16,1			# clock ones digit
# SKEWING FLOOR RELATED RAM
#
#f_shadows,16,1		# flag: do shadows
#f_skew,16,1		# flag: skew the ground
#skew_dx,32,1
#skew_oc,32,1		# how far off (and direction) center
#skew_y,16,1		# starting y position of floor
#skew_height,16,1	# floor height
#skew_stack,16,1		# # of times to stack floor
#skew_constpal,32,1	# skew: const:pal
#skew_calla,32,1		# skew calla
#skew_sag,32,1		# skew ground image pointer
#skew_scroll,32,1	# pointer to which scroller skew uses
# BACKGROUND RELATED VARIABLES
#
var ground_y : int			# ground level y coordinate
#ceiling_y,16,1		# ceiling level y coordinate
#left_edge,16,1
#right_edge,16,1		# scroll limits
#scrtab,32,1		# scroll table
#p1_ram,32*40,1		# player 1 multipart ram
#p2_ram,32*40,1		# player 2 multipart ram
#p1proj_ram,32*40,1  	# player 1 projectile multipart ram
#p2proj_ram,32*40,1	# player 2 projectile multipart ram
#ofree,32		# pointer to free object block
#scrntl,32		# top left [y,x] screen (scrn coord.)
#scrnlr,32		# lower right [y,x] screen (scrn coord.)
#scrntl2,32		# top left [y,x] screen coord (objlst2)
#scrnlr2,32		# lower right [y,x] screen coord (objlst2)
#end_of_dram,0,1		# END OF MK DISPLAY RAM !!
#************************************
#
#     MORTAL KOMBAT GAME SPECIFIC RAM
#
#************************************
#var gamestate : int		# state variable
#switch_escape,16,1 	#
# PLAYER RAM
#
#p1_state,16,1		# player 1 state
#p1_shape,32,1
#p1_obj,32,1		# player 1 object
#p1_button,32,1		# player 1 button table pointer
#p1_proc,32,1		# player 1 process
#p1_char,16,1
#p1_score,8*8,1
#p1_xvel,32,1		# player 1 requested x velocity
#p1_bar,16,1		# player 1 strength bar
#p1_perfect,16,1
#p1_matchw,16,1		# player 1 wins this match
#p1_map,32,1		# player 1 map position
#p1_bcq,32*(sqs+1),1	# player 1 button close queue
#p1_jcq,32*(sqs+1),1	# player 1 joystick close queue
#p1_boq,32*(sqs+1),1	# player 1 button open queue
#p1_joq,32*(sqs+1),1	# player 1 joystick open queue
#p2_state,16,1		# player 2 state
#p2_shape,32,1
#p2_obj,32,1
#p2_button,32,1		# player 2 button table pointer
#p2_proc,32,1		# player 1 process
#p2_char,16,1
#p2_score,8*8,1
#p2_xvel,32,1		# player 2 requested x velocity
#p2_bar,16,1		# player 2 strength bar
#p2_perfect,16,1
#p2_matchw,16,1		# player 2 wins this match
#p2_map,32,1		# player 2 map position
#p2_bcq,32*(sqs+1),1	# player 2 button close queue
#p2_jcq,32*(sqs+1),1	# player 2 joystick close queue
#p2_boq,32*(sqs+1),1	# player 2 button open queue
#p2_joq,32*(sqs+1),1	# player 2 joystick open queue
# GAME VARIABLES & FLAGS
#
#f_nosound,16,1
#f_timeout,16,1		# flag: round timedout
#f_doscore,16,1		# flag: display score/bars/timer
#f_death,16,1		# flag: death blow achieved
#f_norepell,16,1		# flag: don't repell players
var f_start : bool = true	# flag: start a fightin'
#f_auto_erase,16,1	# flag: do auto erase
#f_novel,16,1		# flag: no velocities
#f_warnsound,16,1	# flag: warning sound has been made
#f_nopmsg,16,1		# flag: dont print player message
#f_start_pressed,16,1	# flag: a start button was pressed
#f_hey,16,1		# jon hey yell word
#f_no_violence,16,1	# flag: no violence
#f_no_blood,16,1		# flag: no blood
#f_fade,16,1		# flag: background is faded
#f_no_lb,16,1		# flag: no low blow
#f_thatsall,16,1		# flag: thats all, round iz over !
#pf_ram,32,1		# printf ram
#curback,16,1		# current background
#diff,16,1		# current game difficulty
#perform,16,1		# human performance vs. drone
#round_num,16,1		# round #
var winner_status:int = 0		# 1 = player 1 # 2 = 2 # 3 = finish him
#map_start,32,1
#map_position,16,1
#battle_num,16,1		#
#p1_wiar,16,1		# player 1 wins in a row
#p2_wiar,16,1		# player 2 wins in a row
#p1_rwon,16,1		# player 1 total rounds won
#p2_rwon,16,1		# player 2 total rounds won
#p1_hitq,16*6,1		# player 1 hit queue
#p2_hitq,16*6,1		# player 2 hit queue
#cmos_diff,16,1		# adjustment: drone diff
#silhoette,16,1		# matches sans silhoette
#c_three,16,1		# counter: threes
#c_drone_kill,16,1	# count: drone kill count down
#c_amodeloop,16,1	# counter: attract mode looper
#c_amode_bio,16,1 	# counter: amode bio
#f_secret,16,1
#toasty,16,1	  	# tick state at last toasty
# TIME MARKERS FOR SPECIAL EVENTS
#
#l_slide,32,1		# p1:p2 last tick state of slide
#l_decoy,32,1		# p1:p2 last tick state of decoy
#l_spear,32,1		# p1:p2 last tick state of scorpion spear
#l_warp,32,1		# p1:p2 last tick state of raiden warp
#l_gslam,16,1		# tick state of last goro body slam
#l_gpounce,16,1		# tick state of last goro pounce
#l_gorofire,16,1		# tick state of last goro fire
#l_drone_fk,16,1		# tick state of last flip kick
#l_drone_zap,16,1	# tick state of last zap
#l_throw_fan,32,1	# p1:p2 last tick state fan throw
#l_morph,32,1		# p1:p2 last tick state shang morph
#l_spin,32,1		# p1:p2 last spin move
#l_pud,32,1		# p1:p2 last puddle
#l_drone_slam,32,1
#l_hp,32,1		# p1:p2 last high punch
#l_lp,32,1		# p1:p2 last low punch
#l_block,32,1		# p1:p2 block
#l_hk,32,1		# p1:p2 high kick
#l_lk,32,1		# p1:p2 low kick
#l_kano,32,1		# p1:p2 last kano roll
#c_p1p2_fastblk,32,1	# p1:p2 fast block counter
#mkramend,16,1
#c_kahn_dummy,16,1	# kahn dummy counter
#c_goro_dummy,16,1	# goro dummy counter
#c_sk_taunt,16,1		# sk taunt counter
#f_death2,16,1		# flag: death blow achieved
#f_pit_fall,16,1		# flag
#c_1p_tries,16,1		# counter: 1 player tries
# range clear the "l_" variables (ejbpatch)
# DEBUG RAM
#
#counter_copy,16		# current copy of the coin counter latch
#f_do_psel,16,1		# debug flag: do player select code
#f_colbox,16,1		# flag: show collision box
#last_dma,32,1		# last dma this frame
#octpage,16,1
#f_fastrun,16,1
#debug1,16,1
#debug2,32,1		# debug ram #2 (for tests)
#debug3,32,1		# debug ram #3 (for tests)
#debug4,32,1		# debug ram #4 (for tests)
#debug5,32,1		# debug ram #5 (for tests)
#debug6,32,1		# debug ram #6 (for tests)
#f_sans_throws,16,1
#f_show_ranking,16,1	# flag: showing rankings
##########################################################################
#											     *
#  a6 = control:offset									     *
#  a5 = sag										     *
#  a4 = y:x coordinate									     *
#  a3 = y:x size										     *
#  a2 = const:pal									     *
#  a1 = scale										     *
#											     *
##########################################################################
#p1_knotch1	.set	score_ram_end-(32*3)
#p1_knotch2	.set	p1_knotch1-sns
#p2_knotch1	.set	p1_knotch2-sns
#p2_knotch2	.set	p2_knotch1-sns
#entry_1		.set	score_ram_end-(sns*1)
#entry_2		.set	score_ram_end-(sns*2)
#entry_3		.set	score_ram_end-(sns*3)
#entry_4		.set	score_ram_end-(sns*4)
#entry_5		.set	score_ram_end-(sns*5)
#entry_6		.set	score_ram_end-(sns*6)
#entry_7		.set	score_ram_end-(sns*7)
#entry_8		.set	score_ram_end-(sns*8)
#entry_9		.set	score_ram_end-(sns*9)
#entry_10		.set	score_ram_end-(sns*10)
#entry_13		.set	score_ram_end-(sns*13)
#entry_14		.set	score_ram_end-(sns*14)
#entry_15		.set	score_ram_end-(sns*15)
#entry_16		.set	score_ram_end-(sns*16)
#entry_17		.set	score_ram_end-(sns*17)
#entry_18		.set	score_ram_end-(sns*18)
#entry_19		.set	score_ram_end-(sns*19)
#entry_20		.set	score_ram_end-(sns*20)
#p1_bar_view	.set	(entry_9+(32*3))
#p2_bar_view	.set	(entry_10+(32*3))
#p2_bar_xpos	.set	(entry_10+(32*2))
