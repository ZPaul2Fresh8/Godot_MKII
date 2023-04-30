extends Node

const PROGRAM_FILE = "res://assets/mk2.program"
const GRAPHICS_FILE = "res://assets/mk2.graphics"
const SOUNDS_FILE = "res://assets/mk2.sounds"

# LOADS ASSETS FROM THE GAME AT STARTUP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# OUTPUT FILES TO VERIFY WITH COMPARISON
	
func CreateFiles():
	
	# CHECK IF PROGRAM FILE EXISTS
	if !FileAccess.file_exists(PROGRAM_FILE):
		#
		# PROGRAM ROMS
		#
		var uj12: Array
		var ug12: Array
		
		if FileAccess.file_exists("res://rom/uj12.l31"):
			uj12 = FileAccess.get_file_as_bytes("res://rom/uj12.l31")
			print("uj12.l31 Found: {0} bytes".format({0:uj12.size()}))
		else:
			print("uj12.l31 not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/ug12.l31"):
			ug12 = FileAccess.get_file_as_bytes("res://rom/ug12.l31")
			print("ug12.l31 Found: {0} bytes".format({0:ug12.size()}))
		else:
			print("ug12.l31 not found! Game aborted.")
		
		# INTERLEAVE PROGRAM ROMS
		for x in uj12.size():
			Global.program.append(ug12[x])
			Global.program.append(uj12[x])
		
		# SAVE FILE
		var file = FileAccess.open(PROGRAM_FILE, FileAccess.WRITE)
		file.store_buffer(Global.program)
		
		print("Program Roms successfully interleaved.")

	# CHECK IF GFX FILE EXISTS
	if !FileAccess.file_exists(GRAPHICS_FILE):
		#
		# GRAPHIC ROMS BANK 1
		#
		var ug14 : Array
		var uj14 : Array
		var ug19 : Array
		var uj19 : Array
		
		if FileAccess.file_exists("res://rom/ug14-vid"):
			ug14 = FileAccess.get_file_as_bytes("res://rom/ug14-vid")
			print("ug14-vid Found: {0} bytes".format({0:ug14.size()}))
		else:
			print("ug14-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj14-vid"):
			uj14 = FileAccess.get_file_as_bytes("res://rom/uj14-vid")
			print("uj14-vid Found: {0} bytes".format({0:uj14.size()}))
		else:
			print("uj14-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/ug19-vid"):
			ug19 = FileAccess.get_file_as_bytes("res://rom/ug19-vid")
			print("ug19-vid Found: {0} bytes".format({0:ug19.size()}))
		else:
			print("ug19-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj19-vid"):
			uj19 = FileAccess.get_file_as_bytes("res://rom/uj19-vid")
			print("uj19-vid Found: {0} bytes".format({0:uj19.size()}))
		else:
			print("uj19-vid not found! Game aborted.")
		
		# INTERLEAVE BANK 1 GFX FILES
		print("Interleaving GFX Bank 1...")
		for x in ug14.size():
			Global.graphic.append(ug14[x])
			Global.graphic.append(uj14[x])
			Global.graphic.append(ug19[x])
			Global.graphic.append(uj19[x])
		#print("{0} bytes".format({0:Global.graphic.size()}))
		print("Complete.")

		#
		# GRAPHIC ROMS BANK 2
		#
		var ug16 : Array
		var uj16 : Array
		var ug20 : Array
		var uj20 : Array
		
		if FileAccess.file_exists("res://rom/ug16-vid"):
			ug16 = FileAccess.get_file_as_bytes("res://rom/ug16-vid")
			print("ug16-vid Found: {0} bytes".format({0:ug16.size()}))
		else:
			print("ug16-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj16-vid"):
			uj16 = FileAccess.get_file_as_bytes("res://rom/uj16-vid")
			print("uj16-vid Found: {0} bytes".format({0:uj16.size()}))
		else:
			print("uj16-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/ug20-vid"):
			ug20 = FileAccess.get_file_as_bytes("res://rom/ug20-vid")
			print("ug20-vid Found: {0} bytes".format({0:ug20.size()}))
		else:
			print("ug20-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj20-vid"):
			uj20 = FileAccess.get_file_as_bytes("res://rom/uj20-vid")
			print("uj20-vid Found: {0} bytes".format({0:uj20.size()}))
		else:
			print("uj20-vid not found! Game aborted.")
		
		# INTERLEAVE BANK 2 GFX FILES
		print("Interleaving GFX Bank 2...")
		for x in ug14.size():
			Global.graphic.append(ug16[x])
			Global.graphic.append(uj16[x])
			Global.graphic.append(ug20[x])
			Global.graphic.append(uj20[x])
		#print("{0} bytes".format({0:Global.graphic.size()}))
		print("Complete.")
		
		#
		# GRAPHIC ROMS BANK 3
		#
		var ug17 : Array
		var uj17 : Array
		var ug22 : Array
		var uj22 : Array
		
		if FileAccess.file_exists("res://rom/ug17-vid"):
			ug17 = FileAccess.get_file_as_bytes("res://rom/ug17-vid")
			print("ug17-vid Found: {0} bytes".format({0:ug17.size()}))
		else:
			print("ug17-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj17-vid"):
			uj17 = FileAccess.get_file_as_bytes("res://rom/uj17-vid")
			print("uj17-vid Found: {0} bytes".format({0:uj17.size()}))
		else:
			print("uj17-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/ug22-vid"):
			ug22 = FileAccess.get_file_as_bytes("res://rom/ug22-vid")
			print("ug22-vid Found: {0} bytes".format({0:ug22.size()}))
		else:
			print("ug22-vid not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/uj22-vid"):
			uj22 = FileAccess.get_file_as_bytes("res://rom/uj22-vid")
			print("uj22-vid Found: {0} bytes".format({0:uj22.size()}))
		else:
			print("uj22-vid not found! Game aborted.")
		
		# INTERLEAVE BANK 3 GFX FILES
		print("Interleaving GFX Bank 3...")
		for x in ug14.size():
			Global.graphic.append(ug17[x])
			Global.graphic.append(uj17[x])
			Global.graphic.append(ug22[x])
			Global.graphic.append(uj22[x])
		#print("{0} bytes".format({0:Global.graphic.size()}))
		
		# SAVE FILE
		var file = FileAccess.open(GRAPHICS_FILE, FileAccess.WRITE)
		file.store_buffer(Global.graphic)
		
		print("Graphic Roms succesfully interleaved.")

	# CHECK IF SOUND FILE EXISTS
	if !FileAccess.file_exists(SOUNDS_FILE):
		#
		# SOUND ROMS
		#
		var su2 : Array
		var su3 : Array
		var su4 : Array
		var su5 : Array
		var su6 : Array
		var su7 : Array
		
		if FileAccess.file_exists("res://rom/su2.l1"):
			su2 = FileAccess.get_file_as_bytes("res://rom/su2.l1")
			print("su2.l1 Found: {0} bytes".format({0:su2.size()}))
		else:
			print("su2.l1 not found! Game aborted.")

		if FileAccess.file_exists("res://rom/su3.l1"):
			su3 = FileAccess.get_file_as_bytes("res://rom/su3.l1")
			print("su3.l1 Found: {0} bytes".format({0:su3.size()}))
		else:
			print("su3.l1 not found! Game aborted.")

		if FileAccess.file_exists("res://rom/su4.l1"):
			su4 = FileAccess.get_file_as_bytes("res://rom/su4.l1")
			print("su4.l1 Found: {0} bytes".format({0:su4.size()}))
		else:
			print("su4.l1 not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/su5.l1"):
			su5 = FileAccess.get_file_as_bytes("res://rom/su5.l1")
			print("su5.l1 Found: {0} bytes".format({0:su5.size()}))
		else:
			print("su2.l1 not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/su6.l1"):
			su6 = FileAccess.get_file_as_bytes("res://rom/su6.l1")
			print("su6.l1 Found: {0} bytes".format({0:su6.size()}))
		else:
			print("su6.l1 not found! Game aborted.")
		
		if FileAccess.file_exists("res://rom/su7.l1"):
			su7 = FileAccess.get_file_as_bytes("res://rom/su7.l1")
			print("su7.l1 Found: {0} bytes".format({0:su7.size()}))
		else:
			print("su7.l1 not found! Game aborted.")

		# COMBINE SOUND ROMS
		Global.sound.append_array(su2)
		Global.sound.append_array(su3)
		Global.sound.append_array(su4)
		Global.sound.append_array(su5)
		Global.sound.append_array(su6)
		Global.sound.append_array(su7)
		print("Sound Size: {0} bytes".format({0:Global.sound.size()}))
		
		# SAVE FILE
		var file = FileAccess.open(SOUNDS_FILE, FileAccess.WRITE)
		file.store_buffer(Global.sound)
		
		print("Sound Roms successfully joined.")
	
