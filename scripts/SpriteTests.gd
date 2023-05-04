extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var test : Sprite2D
	var test_img = get_bits("0x0FE58|001C|002C|0000|0000|054C7254|6080")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	pass

func get_bits(header : String) -> Image:
	var image : Image
	var line : Array = header.split("|")
	var bitdepth : int = (header[6].hex_to_int() >> 0xc) & 7
	var buffer : int = 0
	var dimensions : Vector2i = Vector2i(header[1].hex_to_int(), header[2].hex_to_int())
	var location : int = header[5].hex_to_int()
	
	match bitdepth:
		3, 4, 5, 6:
			buffer = 96
		_:
			buffer = 0	
	
	var size : int = dimensions[0] * dimensions[1] * bitdepth + buffer
	
	var bitoffsetstart : float = location % 8
	var gfxstartbyte : int = location / 8
	var bitoffsetend : int = 8 - bitoffsetstart
	var gfxendbyte : int = (location + size + gfxstartbyte + bitoffsetend) / 8
	
	var chunk : PackedByteArray = Global.graphic.slice(gfxstartbyte, gfxendbyte)
	var image_bytes : PackedByteArray
	
	# grab 2 bytes at a time, shift to byte align and put 1 back
	# -2 is because we padded 2 extra bytes above to accommodate this shift process
	var counter = 0
	while counter < chunk.size() -2:
		var byte1 = chunk[counter]
		var byte2 = chunk[counter+1]
		var trimmedbyte = 0
		
		var lsb = byte1 >> bitoffsetstart
		var msb
		
		match bitoffsetstart:
			0:
				var bytes = byte1 << 8 | byte2
				var shiftedbyte = bytes << bitoffsetstart
				trimmedbyte = (shiftedbyte & 0xffff) >> 8
			1:
				msb = (byte2 & 1)
				trimmedbyte = msb << 7 | lsb
			2:
				msb = (byte2 & 3)
				trimmedbyte = msb << 6 | lsb
			3:
				msb = (byte2 & 7)
				trimmedbyte = msb << 5 | lsb
			4:
				msb = (byte2 & 15)
				trimmedbyte = msb << 4 | lsb

			5:
				msb = (byte2 & 31)
				trimmedbyte = msb << 3 | lsb

			6:
				msb = (byte2 & 63)
				trimmedbyte = msb << 2 | lsb

			7:
				msb = (byte2 & 127)
				trimmedbyte = msb << 1 | lsb
		image_bytes.append(trimmedbyte)
		counter = counter + 1
		
		
	
	return image.create_from_data(dimensions[0], dimensions[1], false, Image.FORMAT_RGBA8, chunk)
