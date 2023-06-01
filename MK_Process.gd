#extends Resource
extends Node
class_name MK_Process

# INITALIZING REFS
var mkani = MKANI.new()

# PROCESS STRUCTURE

# MY ADDED VARS
var myobj : Fighter
var mythread : Thread
##
## animation pointer
var ani_ptr : String
var anif_num : int
var anif_max : int

#pdata
var plink									# 0x000 - link ot next table - stored in proc array
var procid : int							# 0x020 - process id
var ptime : int								# 0x030 - sleep time
var psptr									# 0x040 - process stack pointer
var pa11									# 0x060 - register a11 save
var pa10									# 0x080 - register a10 save
var pa9										# 0x0a0 - register a9 save
var pa8										# 0x0c0 - register a8 save
var pwake : Callable						# 0x0e0 - proces to run on wake?

# process storage							# 0x100
var p_joyport								# joystick port location
var p_butport								# button port
var p_otherguy : MK_Object					# other guys object
var p_otheract : int						# other guys last action
var p_otherproc : MK_Process			# other guys process
var p_slave : MK_Object						# slave object
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

func _ready():
	pass

func _process(delta):
	pass

func Go_Idle():
	# STANCE SETUP
	
#	movi	act_stance,a0
#	move	a0,*a13(p_action),w
	# idle animation set. set action id into players process
	p_action = Equates.actions.Act_Stance
	
	#	clr	a9			; assume animation #0
	#	calla	get_char_ani
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)
	
	# test animation - runs all frames once
	#mkani.Set_Animation_Once(self, Equates.ani_ids.ANI_00_STANCE,myobj.Resources.Stance_Anim_Speed)
		
	# get fighters stance animation speed
	#	movi	stance_speeds,a0
	#	calla	get_char_word		; calla FF82EDC0
	#	jauc	init_anirate		; set animation speed

	while Global.f_start == false:
		MKPROC.Sleep(1, self)
		mkani.next_anirate(self)
	
#**************************************************************************
#*											     *
#*  next_anirate - animate according to p_anirate value			     *
#* 											     *
#*  input: a9 = animation frames to use						     *
#*         *a13(p_anitab) = base animation table					     *
#*											     *
#**************************************************************************
#next_anirate
#	move	*a13(p_anicount),a0,w
#	dec	a0
#	move	a0,*a13(p_anicount),w
#	jrne	nexta2						; not time yet
#
#	move	*a13(p_anirate),*a13(p_anicount),w	; reload p_anirate
#	move	*a9,a1,l					; grab a frame
#	jreq	nexta2						; zero = skip
#
#	move	*a8(oflags2),a1,w
#	btst	b_multipart,a1
#	jrne	nexta1
#	callr	frame_a9
#	rets
