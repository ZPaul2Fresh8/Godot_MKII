extends Node
class_name MKUTIL

static func Create_Object(Path : String) -> MK_Object:
	var Obj = MK_Object.new()
	if !Path.is_empty():
		Obj.texture=ResourceLoader.load(Path)
	Obj.centered = false
	return Obj

static func Ground_Object(Obj : MK_Object):
	Obj.position.y = Global.ground_y - Obj.Resources.Ground_Offset

static func Move_Object(Obj : MK_Object, X : int, Y : int):
	Obj.move_local_x(X)
	Obj.move_local_y(Y)
