extends Node
class_name MKPROC

static func Create_Thread(proc_id:int, myproc:MK_Process, callme:Callable) -> Thread:
	# inject proc id
	myproc.procid = proc_id
	
	# add process to pool
	Global.procs.append(myproc)
	
	# create new thread to process it
	var thread = Thread.new()
	
	# fire it
	thread.start(callme, Thread.PRIORITY_NORMAL)
	return thread

static func Sleep(time:float, mkproc:MK_Process):
	# AFTER EACH TICK WE NEED TO CHECK THE MK_PROC FOR A CALLBACK
	mkproc.ptime=time
	while mkproc.ptime > 0:
		
		# delay thread
		OS.delay_msec(Global.TICK_TIME*time)
		mkproc.ptime -= 1

		# check for callback
		if mkproc.pwake != null:
			return
	
static func Suicide(mkproc:MK_Process):
	mkproc.mythread.wait_to_finish()
	mkproc.mythread.free()
