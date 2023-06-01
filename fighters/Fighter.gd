extends MK_Object # (Sprite2D)
class_name Fighter

var Resources : Fighter_Resource
var Segments : Array[Sprite2D]

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

@export var state = states.Null
var player_id = 0
@export var control = controller.Player
@export var health = clampi(0, 0, 161)
var rounds_won : int
const MAX_SEGMENTS = 8

# variables which we can let GD natively handle:
#var map_position

enum states {
	Null,
	Flipping,
	Ducking,
	Standing,
	JumpUp}

enum controller {
	Drone,
	Player,
	Unknown,
	ChoosingFighter,
	FighterChosen}

func _init():
	Resources = Fighter_Resource.new()
	
	# add blank sprites to our fighter
	# to re-use for frame updates
	for i in MAX_SEGMENTS:
		var s = Sprite2D.new()
		s.centered = false
		self.add_child(s)
		Segments.append(s)

func Setup_Fighter(char_id : Equates.fighters):
	# load resource file
	Resources = ResourceLoader.load(Global.Fighter_Resource_Paths[char_id])
	
	Print_Resource()

func Print_Resource():
	print("Name: " + str(Equates.fighters.keys()[Resources.Index]))
	print("Ground Offset: " + str(Resources.Ground_Offset))
