extends Node
class_name Extract

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

# TODO: LOOK INTO ODD HEADERS NOT RIPPING BECAUSE OF ABNORMAL HEADERS
# SOUL SUCKED, TOROS RIPPED, DECAPITATED HEAD, GETTING IMPALED
# AND OTHERS THAT NEED FATALITY PALETTE APPLIED INSTEAD OF NORMAL PALETTE

	
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
	for i in Equates.fighters.size():
		# SKIP FIGHTERS WHO USE THE SAME ASSETS
		# if i != 5 || 9 || 10 || 14 || 15:
		#	continue
		
		var new_palette : bool = true
		
		# IF DIR NON-EXISTENT, CREATE IT FOR CHAR
		if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[i]):
			dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[i])
		
		# GET PTR TO ARRAY OF ANIMATIONS
		var animations : int = Tools.Get_Pointer(FIGHTER_ANIMS_LOC + (i*4))
		
		# MAKE ANIMATION DIRS & GET
		for a in FIGHTER_BASIC_ANI_COUNT:
			
			# IF DIR NON-EXISTENT, CREATE IT FOR ANIMATION #
			if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[i] + "/" + Equates.ani_ids.keys()[a]):
				dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[i] + "/" + Equates.ani_ids.keys()[a])
			
			var ani : int = Tools.Get_Pointer(animations + (a*4))

			# GET FRAME PTRS HERE
			var frame : int = ani
			var frame_num : int  = 0
			while Tools.Get_Long(frame) > 9:
				
				# IF DIR NON-EXISTENT, CREATE IT FOR ANIMATION #
				if !dir.dir_exists("res://assets/images/fighters/" + Equates.fighters.keys()[i] + "/" + Equates.ani_ids.keys()[a] + "/" + str(frame_num)):
					dir.make_dir("res://assets/images/fighters/" + Equates.fighters.keys()[i] + "/" + Equates.ani_ids.keys()[a] + "/" + str(frame_num))
				
				# GET SEGMENT PTRS HERE
				var segment : int = Tools.Get_Pointer(frame)
				var seg_num : int = 0
				while Tools.Get_Long(segment) != 0:
					
					# DRAW SEGMENT
					var image = Tools.Draw_Image(Tools.Get_Pointer(segment), new_palette)
					image.save_png("res://assets/images/fighters/" + Equates.fighters.keys()[i] + "/" + Equates.ani_ids.keys()[a] + "/" + str(frame_num) + "/" + str(seg_num) + ".png")
					
					# RESET FLAG TO USE LAST PALETTE
					new_palette = false
					
					segment += 4
					seg_num += 1

				# get next frame pointer
				frame += 4
				frame_num += 1
