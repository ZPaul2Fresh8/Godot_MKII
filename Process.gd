extends Resource
class_name Process_Resource

# PROCESS STRUCTURE

#pdata
var plink									# 0x000 - link ot next table - stored in proc array
var procid : int							# 0x020 - process id
var ptime : int								# 0x030 - sleep time
var psptr									# 0x040 - process stack pointer
var pa11									# 0x060 - register a11 save
var pa10									# 0x080 - register a10 save
var pa9										# 0x0a0 - register a9 save
var pa8										# 0x0c0 - register a8 save
var pwake									# 0x0e0 - proces to run on wake?

# process storage							# 0x100
var p_joyport								# joystick port location
var p_butport								# button port
var p_otherguy : Object_Resource			# other guys object
var p_otheract : int						# other guys last action
var p_otherproc : Process_Resource			# other guys process
var p_slave : Object_Resource				# slave object
var p_anitab								# current animation table
var p_anirate : int							# animation speed
var p_anicount : int						# animation counter
var p_action : int							# current action
var p_ganiy : int							# ground animation point y
var p_flags									# more flags (see p_flag_bits)
var p_downcount : int						# ticks i have been ducking
var p_store1								# long word storage 1
var p_store2								# long word storage 2
var p_store3								# long word storage 3
var p_store4								# long word storage 4
var p_store5								# long word storage 5
var p_store6								# long word storage 6
var p_store7								# long word storage 7
var p_store8								# long word storage 8
var p_dronevar1								# drone variable 1
var p_stk									# strike table i am using
var p_hitby : int							# i was hit by this last
var p_hit : int								# hit count

enum p_flag_bits {
	pm_joy = 0,			# flag: i am a joystick controlled guy
	pm_finish = 1,		# flag: i get to finish other player off!
	pm_reacting = 2,	# flag: i am reacting to some attack
	pm_sitduck = 3,		# flag: i am a sitting duck
	pm_special = 4,		# flag: i am doing a special move (no doubles)
	pm_alt_pal = 5,		# flag: i am using an alternate palette !!
	pm_corpse = 6,		# flag: i am a wasted drone corpse
	pm_emperor = 7,		# flag: i am the emperor
	pm_gninja = 8		# flag: i am the green ninja
}
