extends MK_Object # (Sprite2D)
class_name Fighter

var Resources : Fighter_Resource



#p1_state,16,1		# player 1 state
#p1_shape,32,1
#p1_obj,32,1		# player 1 object
#p1_button,32,1		# player 1 button table pointer
#p1_proc,32,1		# player 1 process
#p1_char,16,1
#p1_score,8*8,1
#p1_xvel,32,1		# player 1 requested x velocity
#p1_bar,16,1		# player 1 strength bar
#p1_perfect,16,1
#p1_matchw,16,1		# player 1 wins this match
#p1_map,32,1		# player 1 map position
#p1_bcq,32*(sqs+1),1	# player 1 button close queue
#p1_jcq,32*(sqs+1),1	# player 1 joystick close queue
#p1_boq,32*(sqs+1),1	# player 1 button open queue
#p1_joq,32*(sqs+1),1	# player 1 joystick open queue

#@export var state = states.Null
#var ochar:int
var player_id = 0
#@export var control = controller.Player
@export var health = clampi(0, 0, 161)
var rounds_won : int
const MAX_SEGMENTS = 8

enum controller {
	Drone,
	Player,
	Unknown,
	ChoosingFighter,
	FighterChosen}

func _init(charid:int):
	print("Fighter initialized.")
	
	# Load resources
	Resources = ResourceLoader.load(Global.Fighter_Resource_Paths[charid])

	# add blank sprites to our fighter
	# to re-use for frame updates
	for i in MAX_SEGMENTS:
		var s = Sprite2D.new()
		s.centered = false
		self.add_child(s)
		Segments.append(s)
	
	# calculate placement
	oyval = Global.CurrentArena.Ground - Resources.Ground_Offset
	
	ochar=charid
	
	Global.Fighters.append(self)
	Print_Resource()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if get_viewport_rect().has_point(get_local_mouse_position()):
			if event.is_pressed():
				get_tree().root.set_input_as_handled()
				print(Equates.fighters.keys()[ochar])
				
			else:
				pass

func Print_Resource():
	print("Name: " + str(Equates.fighters.keys()[Resources.Index]))
	print("Ground Offset: " + str(Resources.Ground_Offset))
