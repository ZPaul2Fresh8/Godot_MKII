extends Resource
class_name Fighter_Resource

@export_category("Fighter Info")
@export var Name : Equates.fighters
@export var DisplayName : String
@export var Index : int
@export var Nameplate : Texture2D

@export_category("Biography")
@export var BioImage : Texture2D
@export var BioStory : String
@export var EndStory1 : String
@export var EndStory2 : String

@export_category("Palettes")
@export var Primary_Colors : Array[Color]
@export var Secondary_Colors : Array[Color]
@export var Fatality_Colors : Array[Color]
@export var Frozen_Colors : Array[Color]

@export_category("Offsets")
@export var Ground_Offset : int
@export var Shadow_Adjustment : int

@export_category("Animations")
@export var Animation_Path : String
@export var Basic_Animations : Array[Animation]
@export var Special_Animations : Array[Animation]

@export_category("Speeds")
@export var Stance_Anim_Speed : int
@export var Walk_Anim_Speed : int
@export var Walk_BWD_Anim_Speed : int
@export var Turn_Around_Speed : int

@export_category("Walking")
@export var Walk_Velocity : int
@export var Walk_BWD_Velocity : int

@export_category("Misc")
@export var Damage_Reduction : int
@export var unxlate : int

@export_category("Moves")
@export_subgroup("Move 1")
@export var M1_Name : String
@export var M1_Input_Speed : int
@export var M1_Input_1 : Equates.Inputs
@export var M1_Input_2 : Equates.Inputs
@export var M1_Input_3 : Equates.Inputs
@export var M1_Input_4 : Equates.Inputs

@export_subgroup("Fatality 1")
@export var F1_Name : String
@export var F1_Input_Speed : int
@export var F1_Input_1 : Equates.Inputs
@export var F1_Input_2 : Equates.Inputs
@export var F1_Input_3 : Equates.Inputs
@export var F1_Input_4 : Equates.Inputs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
