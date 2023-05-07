extends Node

func Get_Pointer(rom_loc : int) -> int:
	# returns a rom location pointer from a 4-byte
	# game address located at provided rom location
	return (Get_Long(rom_loc) / 8) & 0xfffff

func Get_Word(rom_loc : int) -> int:
	# returns a word value from provided rom location
	
	# convert the address if format was given as game address
	if rom_loc > 0xfffff:
		rom_loc = (rom_loc / 8) & 0xfffff
	
	return Global.program.decode_u8(rom_loc) << 8 | Global.program.decode_u8(rom_loc+1)

func Get_Long(rom_loc : int) -> int:
	# returns a long value from provided rom location
	
	# convert the address if format was given as game address
	if rom_loc > 0xfffff:
		rom_loc = (rom_loc / 8) & 0xfffff
	
	var word1 = Global.program.decode_u8(rom_loc) << 8 | Global.program.decode_u8(rom_loc+1)
	var word2 = Global.program.decode_u8(rom_loc+2) << 8 | Global.program.decode_u8(rom_loc+3)
	return word2 << 16 | word1

func Draw_Blitter(header : int) -> Image:		# DRAWS BLITTER SPRITES
	var width = Tools.Get_Word(header)
	var height = Tools.Get_Word(header+2)
	var data_ptr = Tools.Get_Pointer(header+4)
	
	var byte_width = 1
	var byte_size = 1
	
	# calc char byte size
	if width > 8:
		byte_width = 2
		width = 16
	byte_size = byte_width * height
	
	# GET DATA CHUNK
	var data : PackedByteArray = Global.program.slice(data_ptr, data_ptr+byte_size)
	
	# RED PALETTE
	var red = Color8(255, 0, 0, 255)
	var trans = Color8(0, 0, 0, 0)   
	var palette : PackedColorArray
	palette.append(trans)
	palette.append(red)
	
	# CREATE BIT ARRAY
	var bits = _Bits_To_Bytes(data)
	var image = _Fill_Pixels(width, height, bits, palette, 1)
	
	return image

func Draw_Image(location: int): 				# DRAWS TYPICAL SPRITES
	# GET IMAGE HEADER
	# 0: header location in rom
	# 1: width
	# 2: height
	# 3: offset x
	# 4: offset y
	# 5: gfx location (game address)
	# 6: draw attribute
	# 7: palette (game address)
	var header : Array = Build_Header(location)

	# GET DATA CHUNK
	var bpp : int = header[6] >> 0xc
	var gfx_start : int = (header[5] - (header[5] % 8)) / 8
	var gfx_end : int = gfx_start + ((header[1] * header[2] * bpp) + (header[5] % 8) / 8)
	var data : PackedByteArray = Global.graphic.slice(gfx_start, gfx_end)
	
	# CREATE PALETTE
	var palette : PackedColorArray = Tools.Convert_Palette((header[7] / 8) & 0xfffff)

	# CREATE BIT ARRAY
	var bits = _Bits_To_Bytes(data)

	# TRIM STARTING OFFSET
	bits = bits.slice(header[5] % 8)
	
	# CREATE IMAGE
	var image = _Fill_Pixels(header[1], header[2], bits, palette, bpp)

	# SET META FOR FUTURE REFS
	image.set_meta("Header", header)
	return image

func Build_Header(location : int) -> Array:
	var header : Array
	
	# HEADER STRUCT
	# 0 - add location - for naming/ref purposes
	header.append(location)
	print("%05X" % header[0])
	
	# 1 - width
	header.append(Tools.Get_Word(location))
	print("%04X" % header[1])
	
	# 2 - height
	header.append(Tools.Get_Word(location+2))
	print("%04X" % header[2])
	
	# 3 - offset x
	header.append(Tools.Get_Word(location+4))
	print("%04X" % header[3])
	
	# 4 - offset y
	header.append(Tools.Get_Word(location+6))
	print("%04X" % header[4])
	
	# 5 - graphic location
	header.append(Tools.Get_Long(location+8))
	print("%08X" % header[5])
	
	# 6 - draw attribute
	header.append(Tools.Get_Word(location+12))
	print("%04X" % header[6])
	
	# 7 - palette pointer
	header.append(Tools.Get_Long(location+14))
	print("%08X" % header[7])
	
	return header

func convertBitsToByte(bits):
	var byte_value = 0
	for i in range(bits.size()):
		#byte_value = (byte_value << 1) | bits[i]
		byte_value = (byte_value << 1) | bits[bits.size() - 1 - i]
	return byte_value

func Convert_Palette(location : int) -> PackedColorArray:
	var palette : PackedColorArray
	var size = Tools.Get_Word(location)
	var slice = Global.program.slice(location+2, location+2+size)
	
	for c in range(0, slice.size() * 2, 2):
		var word : int = Tools.Get_Word(location + 2 + c)
		var color = convert555To888(word)
		palette.append(color)
		#print(str("%03d" % (c / 2)) + ": 0x%04X " % word + "(R:%02X " % color.r8 + "G:%02X " % color.g8 + "B:%02X " % color.b8 + "A:%02X)" % color.a8)
	return palette

func convert555To888(color_555 : int) -> Color:
	var red = (color_555 >> 10) & 0x1F
	var green = (color_555 >> 5) & 0x1F
	var blue = color_555 & 0x1F

	red = (red << 3) | (red >> 2)
	green = (green << 3) | (green >> 2)
	blue = (blue << 3) | (blue >> 2)

	return Color8(red, green, blue, 255)

func _Bits_To_Bytes (data : PackedByteArray) -> PackedByteArray:
	# CREATE BIT ARRAY
	var bits : PackedByteArray
	for w in range(data.size()):
		var byte = data[w]
		for b in range(8):
			var bit = (byte >> b) & 1
			bits.append(bit)
	return bits

func _Fill_Pixels(width:int, height:int, bits:PackedByteArray, palette:PackedColorArray, bpp : int) -> Image:
	# CREATE IMAGE
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	var pixel : int = 0
	for y in range(height):
		for x in range(width):
			var slice : PackedByteArray = bits.slice(pixel * bpp, pixel * bpp + bpp)
			var index : int = convertBitsToByte(slice)			
			print(index)
			image.set_pixel(x, y, palette[index])
			pixel += 1
			print("Pixel: " + str(pixel) + " | Color Index: " + str(index))
	return image
