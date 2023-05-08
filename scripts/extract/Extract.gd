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
