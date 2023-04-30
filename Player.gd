extends Resource
class_name Player_Resource

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

var state = states
var player_id = [1, 2, 3, 4]
var char_id = Equates.char_id
var control = controller
var obj = Object_Resource.new()
var proc = Process_Resource.new()
var health = clampi(0, 0, 161)
var rounds_won : int

# variables which we can let GD natively handle:
var map_position

enum states {
	Null,
	Flipping,
	Ducking,
	Standing,
	JumpUp
}

enum controller {
	Drone,
	Player,
	Unknown,
	ChoosingFighter,
	FighterChosen
}
