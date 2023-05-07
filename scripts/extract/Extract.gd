extends Node
class_name Extract

static func Fonts():
	# Small 8 point font. These are normally created with a blitter
	# operation within original hardware
	
	var chars_processed : int = 0
	var font8_chars_loc : int = Bookmarks.FONT8_CHARS_LOC
	
	while chars_processed < 64:
		# get character header
		var char_ptr = Tools.Get_Pointer(font8_chars_loc + (chars_processed * 4))
		var width = Tools.Get_Word(char_ptr)
		var height = Tools.Get_Word(char_ptr+2)
		var data_ptr = Tools.Get_Pointer(char_ptr+4)
		var byte_width = 1
		var byte_size = 1
		
		# calc char byte size
		if width > 8:
			byte_width = 2
			width = 16
		byte_size = byte_width * height
		
		# gather data
		var bytes : PackedByteArray = Global.program.slice(data_ptr, data_ptr+byte_size)
		
		# create RRGGBBAA palette
		var red = Color8(255, 0, 0, 255)
		var trans = Color8(0, 0, 0, 0)   
		var palette : PackedColorArray
		palette.append(trans)
		palette.append(red)
		var image = Tools.Draw_Image(width, height, palette, 1, bytes, 0)
		chars_processed += 1
		image.save_png("E:\\Game Engines\\Godot_v4.0.2-stable_mono_win64\\Projects\\Godot_MKII\\assets\\fonts\\" + str(chars_processed) + ".png")
