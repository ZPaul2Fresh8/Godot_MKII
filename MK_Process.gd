#extends Resource
extends Node
class_name MK_Process

################################################################################
########## CONTROL LOOP FOR BASIC INPUTS AND BASIC MOVES #######################
################################################################################

# MY ADDED VARS
var myobj : Fighter
var mythread : Thread
var myinput = MKINPUT.new()
var mystate = states.Null
var mycontrol = controller.Player
var timestamp_morph:int


# ANIMATION STUFF
var mkani = MKANI.new()
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

# process storage
var p_joyport								# 0x100 - joystick port location
var p_butport								# 0x120 - button port
var p_otherguy : MK_Object					# 0x140 - other guys object
var p_otheract : int						# 0x160 - other guys last action
var p_otherproc : MK_Process				# 0x170 - other guys process
var p_slave : MK_Object						# 0x190 - slave object
var p_anitab								# 0x1b0 - current animation table
var p_anirate : int							# 0x1d0 - animation speed
var p_anicount : int						# 0x1e0 - animation counter
var p_action = Equates.actions.Act_None		# 0x1f0 - current action
var p_ganiy : int							# 0x200 - ground animation point y
var p_flags									# 0x210 -more flags (see p_flag_bits)
var p_downcount : int						# 0x220 -ticks i have been ducking
var p_store1								# 0x230 -long word storage 1
var p_store2								# 0x250 -long word storage 2
var p_store3								# 0x270 -long word storage 3
var p_store4 : Callable						# 0x290 -long word storage 4
var p_store5								# 0x2b0 -long word storage 5
var p_store6								# 0x2d0 -long word storage 6
var p_store7								# 0x2f0 -long word storage 7
var p_store8								# 0x310 -long word storage 8
var p_dronevar1								# 0x330 -drone variable 1
var p_stk									# 0x350 -strike table i am using
var p_hitby : int							# 0x360 -i was hit by this last
var p_hit : int								# 0x370 -hit count

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

func _init(player:int):
	# MUST ADD CLASS AS CHILD FOR _process, _ready etc.!
	# add mkinput class to this class
	add_child(myinput)
	
	mythread = MKPROC.Create_Thread(player, self, Human_Control)

	Global.Controllers.append(self)	

##### HUMAN CONTROL ############################################################

func Human_Control():			#FF82EE20
	# STANCE SETUP
	Set_State(states.Standing)
	Set_Control(controller.Player)

	Sleep(1)

	# idle animation set. set action id into players process
	Set_Action(Equates.actions.Act_Stance)
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)
	
	# WAIT HERE UNTIL ROUND STARTS
	while Global.f_start == false:
		Sleep(1)
		mkani.next_anirate(self)
	
	Human_Control_Loop()

func Human_Control_Loop():		#FF82EFA0
	
	#call(myobj.Resources.M1_Callable)
	
	Set_State(states.Standing)
	
	# CHECK IF FIGHTER IS LAYING DOWN
	if 0x60 > Check_Fighter_Height():
		# CHECK IF PLAYER IS HOLDING DOWN
		if Input.is_action_pressed("down"):
			print("Down Pressed While Char Height < 0x60!")
	
	# RESET TICKS I'VE BEEN DUCKING
	p_downcount = 0
	
	Idle_Stance()
	
	while Global.winner_status == Equates.winner_status.No_Winner:
	
	# TURN AROUND CHECK
		if !Are_We_Facing_Opponent():
			Face_Opponent()
			Reset_Char_Control()
		
		# ROUND STATUS JUMP
		Check_For_End_Round()
		
		#if f_start = false # jump tp FF82EF30
		
		Sleep(1)
		
		# INPUT CHECKS
		if mystate != states.Null:
			
			if Are_We_Blocking():
				# FF8324C0 #
				# NULL STATE
				Disable_All_Buttons()
				#TODO: Check facing direction, flip to face opponent if needed.
				Face_Opponent()
				# JUMP - DO BLOCK HI
				Do_Block_Hi()
				
				while Input.is_action_pressed("bl"):
					#print("Block Pressed")
					Sleep(1)
					
					if Input.is_action_pressed("down"):
						Input_Down()
					
					# TURN AROUND CHECK HERE
					if !Are_We_Facing_Opponent():
						Face_Opponent()
						# JUMP TO FF832580
				
				# SET UNBLOCK HERE
				Do_Unblock_Hi()
				
				# RESET CHAR CONTROL
				print("Reset from Input Loop")
				Reset_Char_Control()
			
			if Input.is_action_pressed("right"):
					Input_Right()
			if Input.is_action_pressed("left"):
					Input_Left()
			if Input.is_action_pressed("up"):
					Input_Up()
			if Input.is_action_pressed("down"):
					Input_Down()
			
		Back_To_Shang_Check()
		
		# rip next frame
		mkani.next_anirate(self)

##### DRONE CONTROL ############################################################

func Drone_Control():
	# STANCE SETUP
	Set_State(states.Standing)
	Set_Control(controller.Drone)

	Sleep(1)

	# idle animation set. set action id into players process
	Set_Action(Equates.actions.Act_Stance)
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)
	
	# WAIT HERE UNTIL ROUND STARTS
	while Global.f_start == false:
		Sleep(1)
		mkani.next_anirate(self)
	
	Drone_Control_Loop()

func Drone_Control_Loop():
	pass

##### INPUT ROUTINES ###########################################################

func Input_Up():				#ff82f3e0
	Check_To_Flip()
	
	Set_State(states.Null)
	
	# theres some extra input checks immediately after UP is pressed @
	# ff831bf0. this checks for an angle input (left/right + up)
	Angle_Check()
	
	Set_State(states.JumpUp)
	
	# Not needed I believe.
	# var myheight = Distance_From_Ground()
	
	Do_Jump_Up()

	# find rev frames (typically after normal animation)
	var seq = mkani.find_ani_part2(self, Equates.ani_ids.ANI_06_JUMP_UP)
	# play frames from seq
	mkani.mframew(self, 3, seq)
	Reset_Char_Control()

func Input_Down():				#ff82f960 / 159 joy.asm
	#print("Down Pressed")
	Disable_All_Buttons()
	Do_Duck()
	
	# joy_getup_entry
	while Input.is_action_pressed("down"):
		#print("Input_Down(): Down is pressed")
		While_Ducking_Start()
	
	joy_back_up()

func Input_Right():				#FF830A60
	Set_Action(Equates.actions.Act_None)
	
	if !myobj.is_flipped_h():
		Walk_Forward("right")
	else:
		Walk_Backward("left")

func Input_Left():				#FF830990
	Set_Action(Equates.actions.Act_None)
	
	if myobj.is_flipped_h():
		Walk_Forward("right")
	else:
		Walk_Backward("left")

##### ANIMATED MOVES ROUTINES ##################################################

func Angle_Check():
	# check for left/right pressed within 3 ticks of up being detected
	for i in 3:
		if Input.is_action_pressed("right"):
			mythread.call(Flip_Right())
		if Input.is_action_pressed("left"):
			mythread.call(Flip_Left())
			Sleep(1)

func Do_Jump_Up():
	#play char audio or jump up
	
	Set_Action(Equates.actions.Act_Jumpup)
	
	# velocity
	#myobj.oyvel = -10 # -0xfff60000 / 0x10000
	# gravity
	#myobj.ograv = 0.5 # 0x8000 / 0x10000
	
	Flight_Call(0, -10, Global.up_grav, Equates.ani_ids.ANI_06_JUMP_UP, 4)
	
	#audio landing sound

func Null_Call():
	pass

func Flight(new_xveloc:float, new_yveloc:float, new_gravity:float, ani_id:int, ani_speed:int):# USED FOR JUMP ATTACKS
	# clear any callable before flight
	p_store4 = Null_Call()
	
	# ani_id -1 = no animation setup needed
	Flight_Call(new_xveloc, new_yveloc, new_gravity, ani_id, ani_speed)

func Flight_Call(new_xveloc:float, new_yveloc:float, new_gravity:float, ani_id:int, ani_speed:int):
	# check if new y velocity is being requested
	if new_yveloc != Equates.Values.dont_touch:
		myobj.oyvel = new_yveloc
		#print("Flight_Call(): Set X Velocity")
	
	# check if new gravity is being requested
	if new_gravity != Equates.Values.dont_touch:
		myobj.ograv = new_gravity
		#print("Flight_Call(): Set Gravity")
	
	# check if new x velocity is being requested
	if new_xveloc != Equates.Values.dont_touch:
		myobj.oxvel = new_xveloc
		#print("Flight_Call(): Set Y Velocity")
	
	# setup animation if needed
	if !ani_id < 0:
		#print("Flight_Call(): Getting Animation...")
		mkani.get_char_ani(self, ani_id)
	
	mkani.init_anirate(self, ani_speed)
	
	if myobj.oyval > p_ganiy:
		#print("Started Underground!")
		myobj.oyval = p_ganiy
	
	# have to trick this into not being equal so the loop behaves like the
	# original game
	myobj.oyval -=1
	
	while myobj.oyval < p_ganiy:
		#print("Loop Achieved")
		#print(str(myobj.oyval) + " : " + str(p_ganiy))
		# flight loop
		Sleep(1)
		
		# NOT WORKING FOR SOME REASON!
		# various calls can be invoked while in mid-air
		# they are checked here
		#p_store4.call()
		#if p_store4 is Callable:
		#	print("Called p_store4")
		#	p_store4.call()
		#else:
		#	print("p_store4 not callable")
		
		mkani.next_anirate(self)
	
	#print("Gravity Removed")
	myobj.ograv = 0
	Clear_Velocities()
	Ground_Me()

func Flip_Right():
	#print("Flipping Right...")
	Do_Angle_Jump(0x40000) #0x40000
	Reset_Char_Control()

func Flip_Left():
	#print("Flip Left Goes Here")
	Do_Angle_Jump(-0x40000) #0x40000
	Reset_Char_Control()

func Do_Angle_Jump(x_veloc:float):
	var flip_rotation
	
	#right-flippin'
	if myobj.is_flipped_h():
		if x_veloc < 0:
			flip_rotation = Equates.ani_ids.ANI_07_FLIP_FORWARD
		else:
			flip_rotation = Equates.ani_ids.ANI_08_FLIP_BACKWARD
	else:	
		if x_veloc < 0:
			flip_rotation = Equates.ani_ids.ANI_08_FLIP_BACKWARD
		else:
			flip_rotation = Equates.ani_ids.ANI_07_FLIP_FORWARD
	
	# do ochar_sound here
	
	Clear_Velocities()
	Set_State(states.Null)
	
	# allow attacks now
	Set_State(states.Flipping)
	Set_Action(Equates.actions.Act_Angle_Jump)
	
	# save starting position
	p_store8 = myobj.oxval
	
	# negate velocity if we're right side guy
	if myobj.is_flipped_h():
		x_veloc = x_veloc * -1
	
	#p_store4 = Angle_Jump_Call()
	Flight_Call(x_veloc, -10, Global.angle_grav, flip_rotation, 3)
	
	# sound 1e of landing on ground
	
	Set_Action(Equates.actions.Act_Land)
	
	Face_Opponent()
	mkani.get_char_ani(self, Equates.ani_ids.ANI_07_FLIP_FORWARD)
	mkani.do_next_frame(self)
	
	Sleep(3)
	Back_To_Shang_Check()

func Angle_Jump_Call():
	print(abs(p_ganiy - myobj.oyval))
	
	next_flip_woosh()
	
	# if on upwards, skip
	if myobj.oyvel < 0: return
	
	if abs(p_ganiy - myobj.oyval) > 0x20: return
	
	# we're close to ground, disable buttons
	Set_State(states.Null)
	
	# clear any flight calls
	p_store4 = Null_Call()

func next_flip_woosh():
	#511: joy.asm
	pass

func Walk_Forward(input:String):
	mkani.init_anirate(self, myobj.Resources.Walk_Anim_Speed)
	if myobj.is_flipped_h():
		myobj.oxvel = (myobj.Resources.Walk_Velocity) * -1
	else:
		myobj.oxvel = (myobj.Resources.Walk_Velocity)
		
	mkani.get_char_ani(self, Equates.ani_ids.ANI_01_WALK_FWD)
	
	while Input.is_action_pressed(input):
		Sleep(1)
		Check_For_End_Round()
		Flip_Input_Check()
		Check_And_Face_Opponent()
		mkani.next_anirate(self)
	
	# check which frame we're ending on. If within frame 1-2, do small step
	if anif_num < 3:
		p_store1 = anif_num
		mkani.get_char_ani(self, Equates.ani_ids.ANI_02_SKIP_FWD)
		anif_num = p_store1
		mkani.animate_a0_frames(self, 0x60002)
	
	Clear_Velocities()
	Reset_Char_Control()

func Flip_Input_Check():
	if Input.is_action_pressed("up"):
		if Input.is_action_pressed("right"):
			Flip_Right()
		else:
			Flip_Left()

func Walk_Backward(input:String):
	mkani.init_anirate(self, myobj.Resources.Walk_BWD_Anim_Speed)
	
	if myobj.is_flipped_h():
		myobj.oxvel = (myobj.Resources.Walk_BWD_Velocity)
	else:
		myobj.oxvel = (myobj.Resources.Walk_BWD_Velocity) * -1
	
	mkani.get_char_ani(self, Equates.ani_ids.ANI_03_WALK_BWD)
	
	while Input.is_action_pressed(input):
		Sleep(1)
		Check_For_End_Round()
		Flip_Input_Check()
		Check_And_Face_Opponent()
		mkani.next_anirate(self)
	
	# check which frame we're ending on. If within frame 1-2, do small step
	if anif_num < 3:
		p_store1 = anif_num
		mkani.get_char_ani(self, Equates.ani_ids.ANI_04_SKIP_BWD)
		anif_num = p_store1
		mkani.animate_a0_frames(self, 0x60002)
	
	Clear_Velocities()
	Reset_Char_Control()

func Idle_Stance():
	# idle animation set. set action id into players process
	Set_Action(Equates.actions.Act_Stance)
	mkani.get_char_ani(self, Equates.ani_ids.ANI_00_STANCE)
	mkani.init_anirate(self, myobj.Resources.Stance_Anim_Speed)

func Fall_On_My_Back():
	pass

func Do_Block_Hi():
	Clear_Velocities()
	var seq:Array[int] = mkani.get_char_ani(self, Equates.ani_ids.ANI_11_BLOCKING)
	mkani.act_mframew(self, 3, Equates.actions.Act_Blockhi, seq)

func Do_Unblock_Hi():
	Set_Action(Equates.actions.Act_None)
	var seq:Array[int] = mkani.find_ani_part2(self, Equates.ani_ids.ANI_11_BLOCKING)
	mkani.mframew(self, 4, seq)

func Do_Duck():					#ff82fe00
	Clear_Velocities()
	Face_Opponent()
	var seq:Array[int] = mkani.get_char_ani(self, Equates.ani_ids.ANI_05_DUCK)
	mkani.act_mframew(self, 2, Equates.actions.Act_Duck, seq)

func While_Ducking_Start():
	# joyd3
	Set_State(states.Ducking)
	While_Ducking()

func While_Ducking():
	#ff82f9f0 JUMP DEST
	# joyd4
	while Input.is_action_pressed("down"):
		#print("While_Ducking(): Down is pressed.")
		
		Set_Action(Equates.actions.Act_Duck)
		
		# ff82fa80
		Sleep(1)
		
		if !Are_We_Facing_Opponent():
			Face_Opponent()
			# don't need to restart as we are in that loop already
			#mythread.call(While_Ducking_Start())
			continue
		
		#joyd5
		Inc_Duck_Counter()
		if Are_We_Blocking():
			Do_Block_Low()
		
		Check_For_End_Round()
	joy_back_up()

func joy_back_up():	
	#joy_back_up
	#print("While_Ducking: Going Back Up")
	Disable_All_Buttons()
	Face_Opponent()
	Do_UnDuck()
	Reset_Char_Control()

func Do_UnDuck():		#ff834830
	var seq2:Array[int] = mkani.get_char_ani(self, Equates.ani_ids.ANI_05_DUCK)
	seq2.reverse()
	mkani.act_mframew(self, 2, Equates.actions.Act_Backup, seq2)
	#print("Reset from Do_Unduck")
	Reset_Char_Control()

func Do_Block_Low():
	#joy_duck_block
	#print("Do_Block_Low(): Blocking Low")
	Disable_All_Buttons
	Do_Block_Low2()

	#joy_duck_block_loop
	while Are_We_Blocking():
		#print("While_Blocking_low(): Blocking Low")
		Sleep(1)
		
		if !Are_We_Facing_Opponent():
			Face_Opponent()
			Do_Block_Low2()
			continue
		
		#jdblk5
		if !Input.is_action_pressed("down"):
			# joy_back_up
			joy_back_up()
		
		Inc_Duck_Counter() # ff830340
		Check_For_End_Round()
		Set_Action(Equates.actions.Act_Blockl)

	#print("Unblocking Low")
	Do_Unblock_Low()
	#JR joyd3 - While_Ducking_Start

func Do_Block_Low2():
	Clear_Velocities()
	Face_Opponent()
	var seq3:Array[int] = mkani.get_char_ani(self, Equates.ani_ids.ANI_12_BLOCKING_CROUCHED)
	mkani.act_mframew(self, 3, Equates.actions.Act_Blockl, seq3)

func Do_Unblock_Low():
	var seq2:Array[int] = mkani.get_char_ani(self, Equates.ani_ids.ANI_12_BLOCKING_CROUCHED)
	seq2.reverse()
	print(seq2)
	mkani.act_mframew(self, 3, Equates.actions.Act_Duck, seq2)

##### GAME FLOW ROUTINES #######################################################

func Back_To_Shang_Check():
	if myobj.ochar == Equates.fighters.SHANG_TSUNG:
		if Global.ticks - timestamp_morph >= 0x200:
			#morph back
			#return to FF861350 (Reset_Char_Control)
			pass
		pass

func Check_For_End_Round():
	match Global.winner_status:
		Equates.winner_status.No_Winner:
			pass
		Equates.winner_status.Player_1_Won:	# P1 Won
			print("P1 Wins - Add thread call here.")
		Equates.winner_status.Player_2_Won:	# P2 Won
			print("P12 Wins")
		Equates.winner_status.Finish_Him:	# Finish Him
			print("Finish Him")

func Check_For_Endgame():
	if !Are_We_Fighter(Equates.fighters.SHAO_KAHN): return
	
	#Do Round win check here for endgame when facing Kahn

##### UTILITY ROUTINES #########################################################

func Reset_Char_Control():		#ff861350
	if Am_I_Airborn():
		Fall_On_My_Back()
	
	Clear_Velocities()
	Back_To_Normal()
	#Reset Process Stack - irrelevant
	Back_To_Shang_Check()
	Check_For_Endgame()
	
	if mycontrol == controller.Player:
		mythread.call(Human_Control_Loop())
	else:
		mythread.call(Drone_Control_Loop())

func Am_I_Airborn() -> bool:					# AKA CHAR_VS_GROUND_COMPARE
	if myobj.oyvel != 0 or myobj.oyval != p_ganiy:
		return true
	return false

func Distance_From_Ground():
	return myobj.Resources.Ground_Offset - Global.CurrentArena.Ground

func Back_To_Normal():
	# reset hit count
	p_hit = 0
	# reset action
	Set_Action(Equates.actions.Act_None)
	# reset stricke table I'm using
	p_stk = 0
	# palette refresh
	Destroy_My_Projectile()

func Destroy_My_Projectile():
	if !is_instance_valid(p_slave):
		return
	p_slave.queue_free()

func Check_To_Flip():
	pass

func Are_We_Fighter(fighter:Equates.fighters) -> bool:
	if myobj.ochar == fighter: return true
	else: return false

func Are_We_Blocking() -> bool:
	# CHECK IF PLAYER IS HOLDING BLOCK
	if Input.is_action_pressed("bl"):
		return true
	else: return false

func Check_Fighter_Height() -> float:
	return Global.CurrentArena.Vertical_Offset - Calculate_Hitbox_Top()

func Calculate_Hitbox_Top() -> float:
	return myobj.global_position.y

func Disable_All_Buttons():
	Set_State(states.Null)

func Check_And_Face_Opponent():
	if Are_We_Facing_Opponent(): return
	Face_Opponent()
	Reset_Char_Control()

func Are_We_Facing_Opponent() -> bool:
	# 	CHECK TO SEE IF WE ARE FACING OPPONENT
	return true

func Face_Opponent():
	pass

func Clear_Velocities():						# AKA stop_me
	myobj.oxvel = 0
	myobj.oyvel = 0
	myobj.ograv = 0
	Global.Velocities[procid] = 0
	#print("Velocities cleared")

func Ground_Me():
	myobj.oyval = p_ganiy

func Set_Action(act_id:Equates.actions):
	p_action = act_id
	#print("Action: " + Equates.actions.keys()[p_action])

func Set_State(state:states):
	mystate = state
	#print("State: " + states.keys()[mystate])

func Set_Control(control:controller):
	mycontrol = control

func Inc_Duck_Counter():
	p_downcount += 1

func Sleep(ticks:int):
	MKPROC.Sleep(ticks, self)
