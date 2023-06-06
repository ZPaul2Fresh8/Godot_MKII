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
		#OS.delay_msec(Global.TICK_TIME*time)
		OS.delay_msec(Global.TICK_TIME)
		mkproc.ptime -= 1
		#print(mkproc.ptime)

		# check for callback
		#if mkproc.pwake = 
			#print("Callback detected")
			#return
	
static func Suicide(mkproc:MK_Process):
	mkproc.mythread.wait_to_finish()
	mkproc.mythread.free()
