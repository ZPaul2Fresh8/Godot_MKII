extends MK_Process
class_name MKMOVES

static func do_hp(myproc:MK_Process):
	#var test = Callable(High_Punch1.bind(myproc))
	var test = Callable(testr)
	#var test = Callable(lp.bind(myproc))
	myproc.pwake = test

func testr():
	print("Test")

func High_Punch1(myproc:MK_Process):
	print("High Punched!!!")
	print("High Punched!!!")
	print("High Punched!!!")
	myproc.mythread.call(myproc.Reset_Char_Control())

class Basic:

	static func High_Punch(mkproc:MK_Process):
		print("High Punched!!!")
		print("High Punched!!!")
		print("High Punched!!!")
		mkproc.mythread.call(mkproc.Reset_Char_Control())

	class Special:
		static func Lao_Teleport():
			print("Teleport Here!")

	class Finishers:
		static func Fatal_Lao_Slicer():
			pass


