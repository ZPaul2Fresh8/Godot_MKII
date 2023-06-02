extends Node
class_name Extract

const PRIMARY_PAL 	= 0x20F22	# PRIMARY PALETTE ARRAY
#const ALT_PAL 		= 0x20F66		# ALTERNATE PALETTE ARRAY
const FATAL_PAL 	= 0x21920	# FATALITY PALETTE ARRAY

static func Fonts():
	# Small 8 point font. These are normally created with a blitter
	# operation within original hardware
	
	var chars_processed : int = 0
	var font8_chars_loc : int = Bookmarks.FONT8_CHARS_LOC
	
	while chars_processed < 64:
		# get character header
		var header : int = Tools.Get_Pointer(font8_chars_loc + (chars_processed * 4))
		var image = Tools.Draw_Blitter(header)
		#var image = Tools.Draw_Image(width, height, palette, 1, bytes, 0)
		
		# 45 = M
		chars_processed += 1
		if image != null:
			image.save_png("res://assets/fonts/" + str(chars_processed) + ".png")
		# MAME Breakpoint For String Display at the startup:
		# FFA59580

static func Animations():
	
	# TODO: UNIQUE PALETTE FOR KAHN TURNING INTO STONE NEEDS ACCOUNT FOR.
	# CURRENTLY USES HIS PRIMARY PALETTE. ALSO SOME SECRET FIGHTER FATALITY
	# PALETTES ARE INCORRECT THIS IS DUE TO THE GAME NOT ORIGINALLY HAVING
	# THEM AND THEY WILL NEED ADDED WHEN THE TIME COMES.
	
	const FIGHTER_ANIMS_LOC = 0x20c2a
	const FIGHTER_BASIC_ANI_COUNT = 66

	var dir = DirAccess.open("res://assets")
	if !dir.dir_exists("res://assets/images"):
		dir.make_dir("res://assets/images")
		dir.make_dir("res://assets/images/fighters")
	else:
		if !dir.dir_exists("res://assets/images/fighters"):
			dir.make_dir("res://assets/images/fighters")
	
	# MAKE FIGHTER DIR & GET ANIMATION PTR
	for char_id in Equates.fighters.size():	# Extract all fighters
	####################### DEBUG OVERRIDE #####################################
	#for char_id in 1:							# Extract just Lao for now
	#	char_id = 0x1
	############################################################################
		
		# IF DIR NON-EXISTENT, CREATE IT FOR CHAR
		if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id]):
			dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id])
		
		# GET PTR TO ARRAY OF ANIMATIONS
		var animations : int = Tools.Get_Pointer(FIGHTER_ANIMS_LOC + (char_id * 4))
		
		# SET SIZE OF ANIMATIONS FOR FIGHTER TYPE
		var ani_count : int
		var ani_name : String
		match char_id:
			0xc:
				ani_count = Equates.ani_ids_kintaro.size()
			0xd:
				ani_count = Equates.ani_ids_kahn.size()
			_:
				ani_count = Equates.ani_ids.size()
				
		
		# MAKE ANIMATION DIRS & GET
		for anim_id in ani_count:
		####################### DEBUG OVERRIDE #################################
		#for anim_id in 1:
		#	anim_id = Equates.ani_ids.ANI_59_GETTING_IMPALED
		########################################################################
			
			# IF DIR NON-EXISTENT, CREATE IT FOR ANIMATION #
			match char_id:
				0xc:
					if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kintaro.keys()[anim_id]):
						dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kintaro.keys()[anim_id])
				0xd:
					if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kahn.keys()[anim_id]):
						dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kahn.keys()[anim_id])
				_:
					if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id]):
						dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id])
			
			# GET ANIMATION POINTER
			var ani_ptr : int = Tools.Get_Pointer(animations + (anim_id * 4))
			
			# IF 0 GOTO NEXT ANIMATION
			if ani_ptr == 0: continue
			
			# GET FRAME PTRS HERE
			var frame : int = ani_ptr
			var frame_num : int  = 0
			while Tools.Get_Long(frame) != 0:
				
				# 0x7780 ARRAY LOC
				var frame_ptr : int = Tools.Get_Long(frame)
				match (frame_ptr):
					0:
						# TERMINATOR / RET
						break
					1:
						# NEXT LONG = PTR TO RESTART OF ANIMATION
						# get jump to location
						var ani_command:int = ((Tools.Get_Long(frame+4) / 8) & 0xfffff)
						
						var frame_jump:int = 0
						# easy frame 0 check
						if ani_ptr == ani_command:
							var file = FileAccess.open("res://assets/images/fighters/" + 
							Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id] + 
							"/" + "1.0.end", FileAccess.WRITE)
						
						# not frame 0, let's do some math
						else:
							#print("Unusual Animation Command Jump for " + str(frame_ptr))
							frame_jump = frame_num - ((frame - ani_command) / 4)
							var file = FileAccess.open("res://assets/images/fighters/" + 
							Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id] + 
							"/" + "1." + str(frame_jump) + ".end", FileAccess.WRITE)
						break
					2:
						# FLIP X
						frame += 4
						continue
					3:
						# ADJUST POSTION
						frame += 6
						continue
					4:
						# ADJUST X & Y POSITIONS
						frame += 8
						continue
					5:
						# NEXT DATA = (LONG)SPRITE PTR
						frame += 4
						continue
					6:
						# NEXT DATA = (LONG)FUNCTION PLAY AUDIO VARIANT
						frame += 8
						continue
					7:
						# NEXT DATA = (LONG)AUDIO ID TO PLAY
						pass
					8:
						# NEXT DATA = (WORD)CHAR ID COMPARE FOR SHARED SPRITES IN NINJAS
						# GET NEXT WORD (CHAR ID)
						while Tools.Get_Long(frame) == 8:
							frame +=4
							if Tools.Get_Word(frame) == char_id:
								frame = Tools.Get_Pointer(frame+2)
								break
							frame +=6
					9:
						pass

				# IF DIR NON-EXISTENT, CREATE IT FOR ANIMATION #
				match char_id:
					0xc:
						if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kintaro.keys()[anim_id] + "/" + str(frame_num)):
							dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kintaro.keys()[anim_id] + "/" + str(frame_num))
					0xd:
						if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kahn.keys()[anim_id] + "/" + str(frame_num)):
							dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids_kahn.keys()[anim_id] + "/" + str(frame_num))
					_:
						if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id] + "/" + str(frame_num)):
							dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" + Equates.ani_ids.keys()[anim_id] + "/" + str(frame_num))
				
				# Static Palette Forcing (Primarily due to cloned fighters)
				Choose_Palette(frame_num, anim_id, char_id)
				
				# CHECK IF MULTI-SEGMENTED FRAME OR NOT BY LOOKING AT PTR VALUE
				if Tools.Is_Frame_MultiSegmented(frame):
					# GET MULTI-SEGMENT PTRS HERE
					var segment : int = Tools.Get_Pointer(frame)
					var seg_num : int = 0
					while Tools.Get_Long(segment) != 0:
						
						# DRAW SEGMENT
						var image = Tools.Draw_Image(Tools.Get_Pointer(segment), seg_num + frame_num + anim_id)
						if image != null:
							var header : Array = image.get_meta("Header")
							match char_id:
								0xc:
									image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
									Equates.ani_ids_kintaro.keys()[anim_id] + "/" + str(frame_num) + "/" +
									str(header[0]) + "_" + str(header[1]) + "_" + str(header[2]) + "_" +
									str(header[3]) + "_" + str(header[4]) + "_" +
									str(header[5]) + "_" + str(header[6]) + "_" +
									str(header[7]) + ".png")
								0xd:
									image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
									Equates.ani_ids_kahn.keys()[anim_id] + "/" + str(frame_num) + "/" +
									str(header[0]) + "_" + str(header[1]) + "_" + str(header[2]) + "_" +
									str(header[3]) + "_" + str(header[4]) + "_" +
									str(header[5]) + "_" + str(header[6]) + "_" +
									str(header[7]) + ".png")
								_:
									image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
									Equates.ani_ids.keys()[anim_id] + "/" + str(frame_num) + "/" +
									str(header[0]) + "_" + str(header[1]) + "_" + str(header[2]) + "_" +
									str(header[3]) + "_" + str(header[4]) + "_" +
									str(header[5]) + "_" + str(header[6]) + "_" +
									str(header[7]) + ".png")
						
						segment += 4
						seg_num += 1

				else:
					# DRAW FRAME
					var image = Tools.Draw_Image(Tools.Get_Pointer(frame), frame_num)
					if image != null:
						match char_id:
							0xc:
								image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
								Equates.ani_ids_kintaro.keys()[anim_id] + "/" + str(frame_num) + "/" + str(frame_num) + ".png")
							0xd:
								image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
								Equates.ani_ids_kahn.keys()[anim_id] + "/" + str(frame_num) + "/" + str(frame_num) + ".png")
							_:
								image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[char_id] + "/" +
								Equates.ani_ids.keys()[anim_id] + "/" + str(frame_num) + "/" + str(frame_num) + ".png")

				# get next frame pointer
				frame += 4
				frame_num += 1
		print(Equates.fighters.keys()[char_id] + " extracted.")

static func Choose_Palette(frame_num:int, ani_id:int, char_id:int):
	# only create palette if on frame 0
	if frame_num != 0: return
	
	match ani_id:
		0:
			Tools.palette = Tools.Convert_Palette(Tools.Get_Pointer(char_id * 4 + PRIMARY_PAL))
		59:
			Tools.palette = Tools.Convert_Palette(Tools.Get_Pointer(char_id * 8 + FATAL_PAL))
		62:
			Tools.palette = Tools.Convert_Palette(Tools.Get_Pointer(char_id * 4 + PRIMARY_PAL))
		65:
			Tools.palette = Tools.Convert_Palette(Tools.Get_Pointer(char_id * 8 + FATAL_PAL))
