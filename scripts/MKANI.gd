extends Node
class_name MKANI

func get_char_ani(mkproc:MK_Process, ani_id:int):
	# SETS THE DIRECTORY OF THE ANIMATION
	# RETURNS INT ARRAY FOR SEQUENCE OF FRAME PLAYBACK
	match mkproc.myobj.ochar:
		Equates.fighters.KINTARO:
			mkproc.ani_ptr = mkproc.myobj.Resources.Animation_Path + str(Equates.ani_ids_kintaro.keys()[ani_id]) + "/"
		Equates.fighters.SHAO_KAHN:
			mkproc.ani_ptr = mkproc.myobj.Resources.Animation_Path + str(Equates.ani_ids_kahn.keys()[ani_id]) + "/"
		_:
			mkproc.ani_ptr = mkproc.myobj.Resources.Animation_Path + str(Equates.ani_ids.keys()[ani_id]) + "/"
	
	# create playback sequence
	var sequence : Array[int]
	for i in DirAccess.get_directories_at(mkproc.ani_ptr):
		sequence.append(int(i))
	sequence.sort()
	
	# reset frame to 0
	mkproc.anif_num = 0
	# store frame count
	mkproc.anif_max = DirAccess.get_directories_at(mkproc.ani_ptr).size()
	
	return sequence

# AKA CALC ANIMATION FIND END
# CHECKS FOR EXPECTED REVERSE FRAME FILE IN DIR
func find_ani_part2(mkproc:MK_Process, ani_id:int) -> Array[int]:
	# set frame dir, no need for sequence return
	get_char_ani(mkproc, ani_id)
	
	# parse 0.rev string file in ani dir into frame sequence
	var rev_frames = FileAccess.get_file_as_string(mkproc.ani_ptr + "0.rev").split("|")
	rev_frames.remove_at(rev_frames.size()-1)
	
	var seq:Array[int]
	for i in rev_frames:
		seq.append(int(i))
	
	#print(seq)
	return seq

# SET ANIMATION RATE
func init_anirate(mkproc:MK_Process, speed:int):
	if speed != 0xfff:
		mkproc.p_anirate = speed
		mkproc.p_anicount = 1
	else:
		mkproc.p_anirate = speed
		mkproc.p_anicount = speed

# AKA ANIMATION RIP FRAME
# ANIMATE ACCORDING TO MK_PROCESS.P_ANIRATE VALUE
func next_anirate(mkproc:MK_Process):
#	next_anirate - animate according to p_anirate value
	
#	move	*a13(p_anicount),a0,w
#	dec	a0
#	move	a0,*a13(p_anicount),w
	mkproc.p_anicount -= 1
	
#	jrne	nexta2						; not time yet
	if mkproc.p_anicount != 0 : return
#
#	move	*a13(p_anirate),*a13(p_anicount),w	; reload p_anirate
#	move	*a9,a1,l					; grab a frame
	mkproc.p_anicount = mkproc.p_anirate
	
#	jreq	nexta2						; zero = skip
	#if !DirAccess.dir_exists_absolute(mkproc.ani_ptr + str(mkproc.anif_num)): return
	
#	move	*a8(oflags2),a1,w
#	btst	b_multipart,a1
#	jrne	nexta1
#	callr	frame_a9
#	rets
#
#	nexta1	callr	do_next_a9_frame
	do_next_frame(mkproc)
	
	#	nexta2	rets

func act_mframew(mkproc:MK_Process, sleep:int, action:Equates.actions, sequence:Array[int]):
	mkproc.Set_Action(action)
	mframew(mkproc, sleep, sequence)

# AKA ANIMATION LOAD CHAIN #
func mframew(mkproc:MK_Process, sleep:int, sequence:Array[int]):
	#print("mframew: " + mkproc.ani_ptr)
	#print("mframew: " + str(mkproc.anif_num))
	
	for i in sequence:
		mkproc.anif_num = i
		#print("SEQ: " + str(mkproc.anif_num))
		do_next_frame(mkproc)
		MKPROC.Sleep(sleep, mkproc)
	
#	while mkproc.anif_num != mkproc.anif_max:
#		do_next_frame(mkproc)
#		MKPROC.Sleep(sleep, mkproc)

func animate_a0_frames(mkproc:MK_Process, value:int):
	var sleep = value >> 0x10
	var loops = (value << 0x10) >> 0x10
	
	for i in loops:
		if do_next_frame(mkproc) == 0 : return
		MKPROC.Sleep(sleep, mkproc)

# AKA ANIMATION LOAD SPRITE
func do_next_frame(mkproc:MK_Process):
#do_next_a9_frame 1121:MKUTIL
#	move	*a9+,a0,l
#	jreq	gnf9			; zero = done
	# anim dir / frame num
	var frame:String = mkproc.ani_ptr + str(mkproc.anif_num) + "/"
	#print("do_next_frame: " + frame)
#	
#	cmpi	ani_lastcom,a0		; animation command ?
#	jrls	gnf8			; yes, do it
	# IF DIR DOESNT EXIST, CHECK FOR ANIM COMMANDS
	if !DirAccess.dir_exists_absolute(frame):
		
		# check for additional ani commands if dir doesn't exist
		var file = DirAccess.get_files_at(mkproc.ani_ptr)
		# should have a file like 0.end, 1.end, 2.end etc
		var ani_lastcom:String = ""
		var ani_jump:String = ""
		
		for f in file.size():
			if file[f].ends_with(".end"):
				ani_lastcom = file[f]
				break
		
		if ani_lastcom == "":
			print("No animation .end found!")
			
			# important to return 0 for various helper routines
			return 0
		
		else:
			if ani_lastcom.begins_with("1"):
				#1.0.end = Jump to Frame 0
				ani_jump = ani_lastcom.substr(2, 1)
				#print(ani_jump)
			
			match ani_lastcom.substr(0,1):
				"0":
					return 0
				"1":	#do_ani_jump
					mkproc.anif_num = int(ani_jump)
				"2":	#do_ani_flip
					pass
				"3":	#do_ani_adjustx
					pass
				"4":	#do_ani_adjustxy
					pass
				"5":	#do_ani_nosleep
					pass
				"6":	#do_ani_calla
					pass
				"7":	#do_ani_sound
					pass
				"8":	#do_ani_ochar_jump
					pass
				"9":	#do_ani_flip_vert
					pass
		
#	callr	ani2
	ani2(mkproc)
	mkproc.anif_num+=1
	#
	#		move	a9,a9			; dont set "zero" flag
	#		clrc
	#	gnf9	rets
	#

# ASSEMBLE SPRITE SEGS AND UPDATE TEXTURES
func ani2 (mkproc:MK_Process):
#ani2	move	a0,*a8(oshape),l	; define current shape !
#	move	*a8(oflags),a4,w	; a4 = flags
#	move	*a8(oimg),a1,l		; a1 = multipart ram
#
#an2	move	*a0+,a5,l		; a5 = img header
#	jreq	an9			; zero ---> done
#
#	move	*a5(isag),*a1+,l	; ram entry #1 = sag
#	move	*a5(isize),a6,l
#	move	a6,*a1+,l		; ram entry #2 = y:x size
#
#	move	*a5(icontrol),a2,w
#	andi	0ffcfH,a2		; clear the "flip" bits
#	move	a4,a3
#	andi	00030H,a3		; look only at the "flip" bits
#	or	a3,a2
#	move	a2,*a1+,w		; ram entry #3 = control word
#
#	move	*a5(ianioffx),a2,w
#	move	*a5(ianioffy),a3,w	; grab animation point offsets
#	btst	b_fliph,a4		; horz flip ?
#	jreq	an3			; no
#
#	neg	a2			; yes, reverse x
#	move	a6,a7
#	zext	a7,w			; a6 = [0,x] size
#	addxy	a7,a2
#
#an3	btst	b_flipv,a4		; vert flip ?
#	jreq	an4
#
#	neg	a3			; reverse ani y
#	sra	16,a6
#	add	a6,a3
#
#an4	move	a2,*a1+,w		; ram entry #4 = dx
#	move	a3,*a1+,w		; ram entry #5 = dy
#	jruc	an2
#
#an9	clr	a0
#	move	a0,*a1,l		; flag: end of multipart pieces
#	clrc
#	rets
#
#anx	setc
#	rets

	var Path = mkproc.ani_ptr + str(mkproc.anif_num) + "/"

	if !DirAccess.dir_exists_absolute(Path):
		print("Error: Animation Path doesn't exist: " & Path)
	
	# parse segments together and update fighter frame
	var files = DirAccess.get_files_at(Path)
	for f in files.size():
		if !files[f].ends_with(".png"): continue
		
		#0=loc #1=width #2=height #3=xoff #4=yoff
		var header = files[f].split("_")
		
		# simply update the offset and texture
		mkproc.myobj.Segments[f].offset = Vector2i(int(header[3])*-1, int(header[4])*-1)
		mkproc.myobj.Segments[f].texture = ResourceLoader.load(Path + files[f])
	
	# remove textures of unused segmented sprites
	for d in range(files.size(), mkproc.myobj.MAX_SEGMENTS):
		mkproc.myobj.Segments[d].texture = null


####################################################################################################

#func Set_Frame(mkproc:MK_Process, ani_id : int, Frame : int):
#	#var Path = get_char_ani(fighter, ani_id) + "/" + str(Frame) + "/"
#	var Path = mkproc.ani_ptr + "/" + str(Frame) + "/"
#	#var Path : String = fighter.Resources.Animation_Path + str(Equates.ani_ids.keys()[ani_id]) + "/" + str(Frame) + "/"
#	#var segs : Array[Sprite2D]
#
#	if !DirAccess.dir_exists_absolute(Path):
#		print("Error: Animation Path doesn't exist")
#
#	# parse segments together and update fighter frame
#	var files = DirAccess.get_files_at(Path)
#	for f in files.size():
#		if !files[f].ends_with(".png"): continue
#
#		#0=loc #1=width #2=height #3=xoff #4=yoff
#		var header = files[f].split("_")
#
#		# simply update the offset and texture
#		mkproc.myobj.Segments[f].offset = Vector2i(int(header[3])*-1, int(header[4])*-1)
#		mkproc.myobj.Segments[f].texture = ResourceLoader.load(Path + files[f])
#
#	# remove textures of unused segmented sprites
#	for d in range(files.size(), mkproc.myobj.MAX_SEGMENTS):
#		mkproc.myobj.Segments[d].texture = null

#func Set_Animation_Once(mkproc:MK_Process, ani_id:Equates.ani_ids, frame_delay:float):
#	# get dir count (frame count)
#	var frames = DirAccess.get_directories_at(mkproc.ani_ptr)
#
#	# iterate through each dir(frame) to make a frame per dir
#	for f in frames.size():
#		Set_Frame(mkproc, ani_id, f)
#		MKPROC.Sleep(frame_delay, mkproc)
