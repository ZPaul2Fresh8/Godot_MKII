extends Node

# LOADS ASSETS FROM THE GAME AT STARTUP

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking up assets...")
	var uj12: Array
	var ug12: Array
	
	# OPEN PROGRAM ROM FILES
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
