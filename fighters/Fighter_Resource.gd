extends Resource
class_name Fighter_Resource

@export_category("Fighter Info")
@export var Name : Equates.fighters
@export var DisplayName : String
@export var Index : int

@export_category("Images")
@export var Nameplate : Texture2D
@export var Select_Image : Texture2D
@export var Versus_Image : Texture2D
@export var BioImage : Texture2D

@export_category("Palettes")
@export var Primary_Colors : Array[Color]
@export var Secondary_Colors : Array[Color]
@export var Fatality_Colors : Array[Color]

@export_category("Offsets")
@export var Ground_Offset : int
@export var Shadow_Adjustment : int

@export_category("Animations")
@export_dir var Animation_Path : String
@export var Basic_Animations : Array[Animation]
@export var Special_Animations : Array[Animation]

@export_category("Speeds")
## Delay time between frames
@export_subgroup("Animations")
@export_range(1, 10, 1) var Walk_Anim_Speed : int
@export_range(1, 10, 1) var Walk_BWD_Anim_Speed : int
@export_range(1, 10, 1) var Stance_Anim_Speed : int
@export_subgroup("Moves")
@export_range(1, 10, 1) var Turn_Around_Speed : int

@export_category("Physics")
@export_range(0x4096, 0x60000, 0x4096) var Walk_Velocity : int
@export_range(0x4096, 0x60000, 0x4096) var Walk_BWD_Velocity : int
@export_range(0, 2, 0.01) var Gravity_Modifier : float = 1


@export_category("Misc")
@export_range(1, 161, 2) var Health : int = 161
@export_range(0, 100, 10) var Damage_Reduction : int
@export_flags("Can Be Finished?") var Flags : int

@export_category("Special Moves")
@export_subgroup("Move 1")
@export var M1_Name : String
@export_range(4, 0x32, 2) var M1_Input_Speed : int
@export var M1_Inputs : Array[Equates.Inputs]
@export var M1_Callable : String

@export_subgroup("Fatality 1")
@export var F1_Name : String
@export var F1_Input_Speed : int
@export var F1_Inputs : Array[Equates.Inputs]

@export_category("Biography")
@export_multiline var BioStory : String
@export_multiline var EndStory1 : String
@export_multiline var EndStory2 : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func testy():
	print("IT WORKED!!!!")
