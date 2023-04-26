extends Resource
class_name Item_Resource

@export var name : String
@export var stackable : bool = false
@export var stackable_max_size : int = 1
@export var image : Texture2D
@export var type : Array = [
	Item_Resource, null
]
