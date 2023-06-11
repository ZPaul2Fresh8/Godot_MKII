extends Node
class_name MKINPUT

################################################################################
########## GLOBAL INPUTS --- INSTANTIATED IN MK_PROCESS ########################
################################################################################

# setup input history structure
var Slot : int = 0
var History_Slot : Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
var TimeStamp_Slot : Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
var Hold_Time : Array = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
var Inputs : Array = [ "up", "down", "left", "right", "hp", "lp", "bl", "hk", "lk", "start"]

# pull some refs
var gamestate = Global.gamestate
	#gs_amode = 0x1,			# game is in attract mode
	#gs_fighting = 0x2,		
	#gs_buyin = 0x3,			
	#gs_psel = 0x4,			# fighter select mode
	#gs_bonus = 0x5,			# bonus count state
	#gs_pfsetup = 0x6,		# pre-fight setup state
	#gs_round_intro = 0x7,	# round intro
	#gs_diag = 0x8,			# game is in diagnostics/audits/adjustments
	#gs_pitfall = 0x9,		# fallin down the pit
	#gs_initials = 0xa,		# enter initials
	#gs_gameover = 0xb,		# game over
	#gs_octopus = 0xc,		# octopus mode
	#gs_post_psel = 0xd,		# post player select mode
	#gs_barge = 0xe,			# player barging in mode
	#gs_sec_intro = 0xf		# intro secret

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(Global.ticks)
	pass
	
	# DO NOT CALL INPUT CHECKS IN _process, they won't get CONSUMED!
	#	for i in Inputs:
	#		if Input.is_action_pressed(i):
	#			History_Slot[Slot] = i
	#			TimeStamp_Slot[Slot] = Global.ticks
	#			Slot +=1
	#			# reset slot after 10th entry
	#			if Slot > 8:
	#				Slot = 0
	#			call(i)

func _input(event):
	# iterate through input array, time stamp it and call corresponding call
	for i in Inputs:
		if Input.is_action_pressed(i):
			if Hold_Time[Inputs.find(i)] == 0:
				History_Slot[Slot] = i
				TimeStamp_Slot[Slot] = Global.ticks
				Hold_Time[Inputs.find(i)] += 1
				Slot +=1
				# reset slot after 10th entry
				if Slot > 9:
					Slot = 0
				call(i)
	# iterate through a button release array
	for i in Inputs:
		if Input.is_action_just_released(i):
			call( i + "_r")
			Hold_Time[Inputs.find(i)] = 0

################################################################################
########## BUTTON PRESS EVENTS #################################################
################################################################################

func up():
	
	#print("MKINPUT: up pressed")
	
	############################################################################
	################ QUICK TEST OF SPECIAL MOVE INPUT VERIFICATION #############
	############################################################################
	var myproc : MK_Process = get_parent()
	var spd = myproc.myobj.Resources.M1_Input_Speed
	var inputs : Array[Equates.Inputs] = myproc.myobj.Resources.M1_Inputs
	
	# set starting and ending slots
	var slot_start = Slot - inputs.size()
	if slot_start < 0:
		slot_start = History_Slot.size() + slot_start
	var time_start = TimeStamp_Slot[slot_start]
	
	var slot_end = Slot - 1
	if slot_end < 0:
		slot_end = History_Slot.size() + slot_end
	var time_end = TimeStamp_Slot[slot_end]
	
	var slot_next = slot_start
	if slot_next == History_Slot.size():
		slot_next = slot_next - History_Slot.size()
	
	for s in inputs.size():
		if (slot_next + s) >= History_Slot.size():
			slot_next = (slot_next + s) - History_Slot.size()
		
		# validate sequence through history and move requirements
		if History_Slot[slot_next + s] != Equates.Inputs.keys()[inputs[s]]:
			return
	
	if (time_end - time_start) < spd:
		#call(myproc.myobj.Resources.M1_Callable)
		#myproc.myobj.Resources.testy()
		print("Inputs Successful. Time Taken: " + str(time_end - time_start) +
		 " | Time Required: " + str(spd))
		print(str(time_end) + " | " + str(time_start))
	
func down():
	if Hold_Time[1] == 1 :
		pass
		#print("MKINPUT: down pressed")
	
func left():
	if Hold_Time[2] == 1 :
		pass
		#print("MKINPUT: left pressed")
	
func right():
	if Hold_Time[3] == 1 :
		pass
		#print("MKINPUT: right pressed")
	
func hp():
	if Hold_Time[4] == 1 :
		pass
		#print("MKINPUT: hp pressed")
	
func lp():
	if Hold_Time[5] == 1 :
		pass
		#print("MKINPUT: lp pressed")
	
func bl():
	if Hold_Time[6] == 1 :
		pass
		#print("MKINPUT: bl pressed")
	
func hk():
	if Hold_Time[7] == 1 :
		pass
		#print("MKINPUT: hk pressed")
	
func lk():
	if Hold_Time[8] == 1 :
		pass
		#print("MKINPUT: lk pressed")
	
func start():
	if Hold_Time[9] == 1 :
		pass
		#print("MKINPUT: start pressed")

################################################################################
########## BUTTON RELEASE EVENTS ###############################################
################################################################################

func up_r():
	pass
	#print("MKINPUT: up was held for " + str(Hold_Time[0]))

func down_r():
	pass
	#print("MKINPUT: down was held for " + str(Hold_Time[1]))

func left_r():
	pass
	#print("MKINPUT: left was held for " + str(Hold_Time[2]))

func right_r():
	pass
	#print("MKINPUT: right was held for " + str(Hold_Time[3]))

func hp_r():
	pass
	#print("MKINPUT: hp was held for " + str(Hold_Time[4]))

func lp_r():
	pass
	#print("MKINPUT: lp was held for " + str(Hold_Time[5]))

func bl_r():
	pass
	#print("MKINPUT: bl was held for " + str(Hold_Time[6]))

func hk_r():
	pass
	#print("MKINPUT: hk was held for " + str(Hold_Time[7]))

func lk_r():
	pass
	#print("MKINPUT: lk was held for " + str(Hold_Time[8]))

func start_r():
	pass
	#print("MKINPUT: start was held for " + str(Hold_Time[9]))
