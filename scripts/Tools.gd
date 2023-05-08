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
	
	# calc char byte size
	if width > 8:
		byte_width = 2
		width = 16
	else:
		width = 8
	
	# GET DATA CHUNK
	var data : PackedByteArray = Global.program.slice(data_ptr, data_ptr + (byte_width * height))
	
	# REARRANGE BYTES BACK TO BIG ENDIAN
	var temp_data : PackedByteArray
	for i in range (0, data.size(), 2):
		temp_data.append(data[i+1])
		temp_data.append(data[i])	
	data = temp_data
	
	# RED PALETTE
	var palette : PackedColorArray = [Color8(0, 0, 0, 0), (Color8(255, 0, 0, 255))]
	
	# CREATE BIT ARRAY
	var bits : PackedByteArray = _Bits_To_Bytes(data)

	# CREATE IMAGE
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)	
	for y in range(height):
		for x in range(width):
			image.set_pixel(x, y, palette[bits[0]])
			bits = bits.slice(1)
	return image

func Draw_Image(location: int) -> Image:		# DRAWS TYPICAL SPRITES
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
	var image = _Fill_Pixels(header[1], header[2], bits, palette, header[6])

	# SET META FOR FUTURE REFS
	image.set_meta("Header", header)
	return image

func Build_Header(location : int) -> Array:
	var header : Array
	
	# HEADER STRUCT
	# 0 - add location - for naming/ref purposes
	header.append(location)
	#print("%05X" % header[0])
	
	# 1 - width
	header.append(Tools.Get_Word(location))
	#print("%04X" % header[1])
	
	# 2 - height
	header.append(Tools.Get_Word(location+2))
	#print("%04X" % header[2])
	
	# 3 - offset x
	header.append(Tools.Get_Word(location+4))
	#print("%04X" % header[3])
	
	# 4 - offset y
	header.append(Tools.Get_Word(location+6))
	#print("%04X" % header[4])
	
	# 5 - graphic location
	header.append(Tools.Get_Long(location+8))
	#print("%08X" % header[5])
	
	# 6 - draw attribute
	header.append(Tools.Get_Word(location+12))
	#print("%04X" % header[6])
	
	# 7 - palette pointer
	header.append(Tools.Get_Long(location+14))
	#print("%08X" % header[7])
	
	return header

func convertBitsToByte(bits : PackedByteArray):
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
		if c == 0:
			palette.append(Color.TRANSPARENT)
			continue
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
	# USING FOR TYPICAL SPRITES
	var bits : PackedByteArray
	for w in range(data.size()):
		var byte = data[w]
		for b in range(8):
			var bit = (byte >> b) & 1
			bits.append(bit)
	return bits
	
func _Bits_To_Byte (bits : PackedByteArray) -> int:
	var new_byte : int = 0
	#bits.reverse()
	for w in range(bits.size()):
		if bits[w]:
			new_byte |= (1 << w)
	return new_byte

func _Fill_Pixels(width:int, height:int, bits:PackedByteArray, palette:PackedColorArray, draw_att : int) -> Image:
	# DRAW ATTTRIBUTE BITS
	# FEDC BA98 7654 3210
	# |___________________ DMA GO / DMA HALT
	#  |__________________ BIT DEPTH
	#   |_________________ BIT DEPTH
	#    |________________ BIT DEPTH
	#
	#      |______________ DMA COMPRESS TRAIL PIX MULTIPLIER BIT 1
	#       |_____________ DMA COMPRESS TRAIL PIX MULTIPLIER BIT 0
	#        |____________ DMA COMPRESS LEAD  PIX MULTIPLIER BIT 1
	#         |___________ DMA COMPRESS LEAD  PIX MULTIPLIER BIT 0
	#
	#           |_________ COMPRESSION ENABLED
	#            |________ DMA CLIP ON = 1 (USING U,D,L,R METHOD)
	#             |_______ FLAG - Y DRAW START (0=TOP; 1=BOTTOM) - PBV - VFL
	#              |______ FLAG - X DRAW START (0=LEFT; 1=RIGHT) - PBH - HFL
	#
	#                |____ PIXEL CONSTANT/SUBSTITUTION OPS - NOT USED IN MK (blit nonzero pixels as color)
	#                 |___ PIXEL CONSTANT/SUBSTITUTION OPS - NOT USED IN MK (blit zero pixel as color)
	#                  |__ PIXEL CONSTANT/SUBSTITUTION OPS - NOT USED IN MK (blit nonzero pixels)
	#                   |_ PIXEL CONSTANT/SUBSTITUTION OPS - NOT USED IN MK (blit zero pixels)
	
	# CREATE IMAGE
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	var bpp : int = draw_att >> 0xc
	var pixel : int = 0
	
	for y in range(height):
		# CHECK FOR MULTIPLYING OF COMPRESSED 0-PIXELS
		# 11   10   09   08  ->   BIT
		# TM1  TM0  LM1  LM0       MULTIPLIER
		# -----------------------------------
		# X    X    0    0       X 1 TO LEADING PIXELS
		# X    X    0    1       X 2 TO LEADING PIXELS
		# X    X    1    0       X 4 TO LEADING PIXELS
		# X    X    1    1       X 8 TO LEADING PIXELS
		# 0    0    X    X       X 1 TO TRAILING PIXELS
		# 0    1    X    X       X 2 TO TRAILING PIXELS
		# 1    0    X    X       X 4 TO TRAILING PIXELS
		# 1    1    X    X       X 8 TO TRAILING PIXELS
		
		var cmp_leading : int = 0
		var cmp_trailing : int = 0
		if _Is_Sprite_Compressed(draw_att):
			
			# get compression byte
			var cmp_byte : int = _Bits_To_Byte(PackedByteArray(bits.slice(0, 8)))
			# trim off compression byte
			bits = bits.slice(8)
			
			cmp_leading = cmp_byte & 0xf
			cmp_trailing = cmp_byte >> 4
			
			# leading blank pixel multiplication
			if (_Is_Bit_Set(draw_att, 8)):
				if (_Is_Bit_Set(draw_att, 9)):
					cmp_leading = cmp_leading * 8
				else:
					cmp_leading = cmp_leading * 2
			elif (_Is_Bit_Set(draw_att, 9)):
				cmp_leading = cmp_leading * 4
			
			# trailing blank pixel multiplication
			if (_Is_Bit_Set(draw_att, 10)):
				if(_Is_Bit_Set(draw_att, 11)):
					cmp_trailing = cmp_trailing * 8
				else:
					cmp_trailing = cmp_trailing * 2
			elif (_Is_Bit_Set(draw_att, 11)):
				cmp_trailing = cmp_trailing * 4

		for x in range(width):
			var slice : PackedByteArray = bits.slice(0, bpp)
			var index : int = convertBitsToByte(slice)
			
			if (x < cmp_leading or x >= (width - cmp_trailing)):
				
				# DEBUG - show compressed pixels
				image.set_pixel(x, y, Color8(0, 255, 0, 255))
				index = 0
				continue
			else:
				# only remove pixel data if not compressed 
				bits = bits.slice(bpp)
				
			if index < palette.size():
				image.set_pixel(x, y, palette[index])
			
			pixel += 1
			#print("Pixel: " + str("%04d" % pixel) + " | Color Index: " + str(index))
	return image

func _Is_Sprite_Compressed(draw_att : int) -> bool:
	return (draw_att & 0x80) >> 7 == 1

func _Is_Bit_Set(value : int, bit : int) -> bool:
	return ((value & (1 << bit)) != 0)
