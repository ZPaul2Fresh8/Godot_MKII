extends Node

# LOADS ASSETS FROM THE GAME AT STARTUP

# Called when the node enters the scene tree for the first time.
func _ready():
	#
	# PROGRAM ROMS
	#
	var uj12: Array
	var ug12: Array
	
	if FileAccess.file_exists("res://rom/uj12.l31"):
		var file = FileAccess.open("res://rom/uj12.l31", FileAccess.READ)
		uj12 = file.get_file_as_bytes("res://rom/uj12.l31")
		print("uj12.l31 Found: {0} bytes".format({0:uj12.size()}))
	else:
		print("uj12.l31 not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/ug12.l31"):
		var file = FileAccess.open("res://rom/ug12.l31", FileAccess.READ)
		ug12 = file.get_file_as_bytes("res://rom/ug12.l31")
		print("ug12.l31 Found: {0} bytes".format({0:ug12.size()}))
	else:
		print("ug12.l31 not found! Game aborted.")
	
	# INTERLEAVE PROGRAM ROMS
	for x in uj12.size():
		Global.program.append(ug12[x])
		Global.program.append(uj12[x])
	
	print("Program Roms successfully interleaved.")
	
	
	#
	# GRAPHIC ROMS BANK 1
	#
	var ug14 : Array
	var uj14 : Array
	var ug19 : Array
	var uj19 : Array
	
	if FileAccess.file_exists("res://rom/ug14-vid"):
		var file = FileAccess.open("res://rom/ug14-vid", FileAccess.READ)
		ug14 = file.get_file_as_bytes("res://rom/ug14-vid")
		print("ug14-vid Found: {0} bytes".format({0:ug14.size()}))
	else:
		print("ug14-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj14-vid"):
		var file = FileAccess.open("res://rom/uj14-vid", FileAccess.READ)
		uj14 = file.get_file_as_bytes("res://rom/uj14-vid")
		print("uj14-vid Found: {0} bytes".format({0:uj14.size()}))
	else:
		print("uj14-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/ug19-vid"):
		var file = FileAccess.open("res://rom/ug19-vid", FileAccess.READ)
		ug19 = file.get_file_as_bytes("res://rom/ug19-vid")
		print("ug19-vid Found: {0} bytes".format({0:ug19.size()}))
	else:
		print("ug19-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj19-vid"):
		var file = FileAccess.open("res://rom/uj19-vid", FileAccess.READ)
		uj19 = file.get_file_as_bytes("res://rom/uj19-vid")
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
		var file = FileAccess.open("res://rom/ug16-vid", FileAccess.READ)
		ug16 = file.get_file_as_bytes("res://rom/ug16-vid")
		print("ug16-vid Found: {0} bytes".format({0:ug16.size()}))
	else:
		print("ug16-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj16-vid"):
		var file = FileAccess.open("res://rom/uj16-vid", FileAccess.READ)
		uj16 = file.get_file_as_bytes("res://rom/uj16-vid")
		print("uj16-vid Found: {0} bytes".format({0:uj16.size()}))
	else:
		print("uj16-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/ug20-vid"):
		var file = FileAccess.open("res://rom/ug20-vid", FileAccess.READ)
		ug20 = file.get_file_as_bytes("res://rom/ug20-vid")
		print("ug20-vid Found: {0} bytes".format({0:ug20.size()}))
	else:
		print("ug20-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj20-vid"):
		var file = FileAccess.open("res://rom/uj20-vid", FileAccess.READ)
		uj20 = file.get_file_as_bytes("res://rom/uj20-vid")
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
		var file = FileAccess.open("res://rom/ug17-vid", FileAccess.READ)
		ug17 = file.get_file_as_bytes("res://rom/ug17-vid")
		print("ug17-vid Found: {0} bytes".format({0:ug17.size()}))
	else:
		print("ug17-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj17-vid"):
		var file = FileAccess.open("res://rom/uj17-vid", FileAccess.READ)
		uj17 = file.get_file_as_bytes("res://rom/uj17-vid")
		print("uj17-vid Found: {0} bytes".format({0:uj17.size()}))
	else:
		print("uj17-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/ug22-vid"):
		var file = FileAccess.open("res://rom/ug22-vid", FileAccess.READ)
		ug22 = file.get_file_as_bytes("res://rom/ug22-vid")
		print("ug22-vid Found: {0} bytes".format({0:ug22.size()}))
	else:
		print("ug22-vid not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/uj22-vid"):
		var file = FileAccess.open("res://rom/uj22-vid", FileAccess.READ)
		uj22 = file.get_file_as_bytes("res://rom/uj22-vid")
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
	print("Graphic Roms succesfully interleaved.")
	
	
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
		var file = FileAccess.open("res://rom/su2.l1", FileAccess.READ)
		su2 = file.get_file_as_bytes("res://rom/su2.l1")
		print("su2.l1 Found: {0} bytes".format({0:su2.size()}))
	else:
		print("su2.l1 not found! Game aborted.")

	if FileAccess.file_exists("res://rom/su3.l1"):
		var file = FileAccess.open("res://rom/su3.l1", FileAccess.READ)
		su3 = file.get_file_as_bytes("res://rom/su3.l1")
		print("su3.l1 Found: {0} bytes".format({0:su3.size()}))
	else:
		print("su3.l1 not found! Game aborted.")

	if FileAccess.file_exists("res://rom/su4.l1"):
		var file = FileAccess.open("res://rom/su4.l1", FileAccess.READ)
		su4 = file.get_file_as_bytes("res://rom/su4.l1")
		print("su4.l1 Found: {0} bytes".format({0:su4.size()}))
	else:
		print("su4.l1 not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/su5.l1"):
		var file = FileAccess.open("res://rom/su5.l1", FileAccess.READ)
		su5 = file.get_file_as_bytes("res://rom/su5.l1")
		print("su5.l1 Found: {0} bytes".format({0:su5.size()}))
	else:
		print("su2.l1 not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/su6.l1"):
		var file = FileAccess.open("res://rom/su6.l1", FileAccess.READ)
		su6 = file.get_file_as_bytes("res://rom/su6.l1")
		print("su6.l1 Found: {0} bytes".format({0:su6.size()}))
	else:
		print("su6.l1 not found! Game aborted.")
	
	if FileAccess.file_exists("res://rom/su7.l1"):
		var file = FileAccess.open("res://rom/su7.l1", FileAccess.READ)
		su7 = file.get_file_as_bytes("res://rom/su7.l1")
		print("su7.l1 Found: {0} bytes".format({0:su7.size()}))
	else:
		print("su7.l1 not found! Game aborted.")

	# COMBINE SOUND ROMS
	Global.sound.append(su2)
	Global.sound.append(su3)
	Global.sound.append(su4)
	Global.sound.append(su5)
	Global.sound.append(su6)
	Global.sound.append(su7)
	print("Sound Roms successfully joined.")
	
	# OUTPUT FILES TO VERIFY WITH COMPARISON
	
