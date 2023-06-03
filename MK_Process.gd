#extends Resource
extends Node
class_name MK_Process

# INITALIZING REFS
var mkani = MKANI.new()

# PROCESS STRUCTURE

# MY ADDED VARS
var myobj : Fighter
var mythread : Thread
var mystate = states.Null
var mycontrol = controller.None
var timestamp_morph:int

# ANIMATION STUFF
var ani_ptr : String
var anif_num : int
var anif_max : int

enum states {
	Null,
	Flipping,
	Ducking,
	Standing,
	JumpUp }
enum controller {
	None,
	Drone,
	Player }

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

func Human_Control(): #FF82EE20
	# STANCE SETUP
	mystate = states.Standing
	mycontrol = controller.Player
	MKPROC.Sleep(1, self)

	# idle animation set. set action id into players process
	p_action = Equates.actions.Act_Stance
	
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)
	
	# WAIT HERE UNTIL ROUND STARTS
	while Global.f_start == false:
		MKPROC.Sleep(1, self)
		mkani.next_anirate(self)
	
	mystate = states.Standing
	print(states.keys()[mystate])
	
	# CHECK IF FIGHTER IS LAYING DOWN
	#print(Check_Fighter_Height())
	
	# CHECK IF PLAYER IS HOLDING DOWN
	if Input.is_action_pressed("down"):
		print("Down Pressed -- Go To Duck Routine!")
	
	# RESET TICKS I'VE BEEN DUCKING
	p_downcount = 0
	Idle_Stance()
	
	while Global.winner_status == Equates.winner_status.No_Winner:
		# TURN AROUND CHECK

		
		# ROUND STATUS JUMP
		match Global.winner_status:
			1:	# P1 Won
				pass
			2:	# P2 Won
				pass
			3:	# Finish Him
				pass
		
		#if f_start = false # jump tp FF82EF30
		
		MKPROC.Sleep(1, self)
		
		# INPUT CHECKS
		if Are_We_Blocking():
			Disable_All_Buttons()
			#TODO: Check facing direction, flip to face opponent if needed.
			Face_Opponent()
			Do_Block_Hi()

		if Input.is_action_pressed("right"):
				print("Right Pressed")
		if Input.is_action_pressed("left"):
				print("Left Pressed")
		if Input.is_action_pressed("up"):
				print("Up Pressed")
		if Input.is_action_pressed("down"):
				print("Down Pressed")
		
		Back_To_Shang_Check()
		
		# rip next frame
		mkani.next_anirate(self)
	

func Idle_Stance():
	# idle animation set. set action id into players process
	p_action = Equates.actions.Act_Stance
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)

func Are_We_Blocking() -> bool:
	# CHECK IF PLAYER IS HOLDING BLOCK
	if Input.is_action_pressed("Block"):
		return true
	else: return false

func Back_To_Shang_Check():
	if myobj.char_id == Equates.fighters.SHANG_TSUNG:
		if Global.ticks - timestamp_morph >= 0x200:
			#morph back
			#return to FF861350 (Reset_Char_Control)
			pass
		pass

func Check_Fighter_Height() -> int:
	return Global.CurrentArena.Vertical_Offset - Calculate_Hitbox_Top()

func Calculate_Hitbox_Top() -> int:
	return myobj.global_position.y

func Disable_All_Buttons():
	mystate = states.Null

func Face_Opponent():
	pass

func Do_Block_Hi():
	Clear_Velocities()
	mkani.get_char_ani(self, Equates.ani_ids.ANI_11_BLOCKING)
	p_action = Equates.actions.Act_Blockhi
	
	#no worky
	Thread_Jump(Animate_Block())
	
	#worky
	#var temp_thread = Thread.new()
	#temp_thread.start(Animate_Block)
	#temp_thread.wait_to_finish()
	
	#mythread.wait_to_finish()
	print("All finished")

func Thread_Jump(call:Callable):
	var temp_thread = Thread.new()
	temp_thread.start(Animate_Block)
	temp_thread.wait_to_finish()
	print("All finished")

func Animate_Block():
	print("In animation thread")
	MKPROC.Sleep(80, self)

func Clear_Velocities():
	myobj.oxvel = 0
	myobj.oyvel = 0
	myobj.ograv = 0
