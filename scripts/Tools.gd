extends Node

func Get_Pointer(rom_loc : int):
	# returns a rom location pointer from a 4-byte
	# game address located at provided rom location
	return (Get_Long(rom_loc) / 8) & 0xfffff


func Get_Word(rom_loc : int):
	# returns a word value from provided rom location
	
	# convert the address if format was given as game address
	if rom_loc > 0xfffff:
		rom_loc = (rom_loc / 8) & 0xfffff
	
	return Global.program.decode_u8(rom_loc) << 8 | Global.program.decode_u8(rom_loc+1)


func Get_Long(rom_loc : int):
	# returns a long value from provided rom location
	
	# convert the address if format was given as game address
	if rom_loc > 0xfffff:
		rom_loc = (rom_loc / 8) & 0xfffff
	
	var word1 = Global.program.decode_u8(rom_loc) << 8 | Global.program.decode_u8(rom_loc+1)
	var word2 = Global.program.decode_u8(rom_loc+2) << 8 | Global.program.decode_u8(rom_loc+3)
	return word2 << 16 | word1


func Draw_Image(width : int, height : int, palette : PackedColorArray, bpp : int, data : PackedByteArray, skipbit : int):
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)

	var bits : PackedByteArray
	for w in range(data.size()):
		var byte = data[w]
		#for b in range(7, -1, -1):
		for b in range(8):
			var bit = (byte >> b) & 1
			bits.append(bit)

	if skipbit != 0:
		bits = bits.slice(skipbit)
	
	var pixel : int = 0
	for y in range(height):
		for x in range(width):
			var slice : PackedByteArray = bits.slice(pixel * bpp, pixel * bpp + bpp)
			var index : int = convertBitsToByte(slice)			
			image.set_pixel(x, y, palette[index])
			pixel += 1
			print(index)
	
	image.save_png("E:\\Game Engines\\Godot_v4.0.2-stable_mono_win64\\Projects\\Godot_MKII\\assets\\test.png")
	return image


func convertBitsToByte(bits):
	var byte_value = 0

	for i in range(bits.size()):
		#byte_value = (byte_value << 1) | bits[i]
		byte_value = (byte_value << 1) | bits[bits.size() - 1 - i]
	return byte_value


func Convert_Palette(location : int) -> PackedColorArray:
	var pca : PackedColorArray
	var size = Tools.Get_Word(location)
	var slice = Global.program.slice(location+2, location+2+size)
	
	for c in range(0, slice.size() * 2, 2):
		var word : int = Tools.Get_Word(location + 2 + c)
		var color = convert555To888(word)
		pca.append(color)
		#print(str("%03d" % (c / 2)) + ": 0x%04X " % word + "(R:%02X " % color.r8 + "G:%02X " % color.g8 + "B:%02X " % color.b8 + "A:%02X)" % color.a8)

	return pca


func convert555To888(color_555) -> Color:
	var red = (color_555 >> 10) & 0x1F
	var green = (color_555 >> 5) & 0x1F
	var blue = color_555 & 0x1F

	red = (red << 3) | (red >> 2)
	green = (green << 3) | (green >> 2)
	blue = (blue << 3) | (blue >> 2)

	return Color8(red, green, blue, 255)
