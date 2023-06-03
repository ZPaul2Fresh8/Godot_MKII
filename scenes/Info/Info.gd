extends Window

func _ready():
	pass
	#print_tree_pretty()

func _on_close_requested():
	self.queue_free()
