extends State

func OnEnter():
	print_debug("masuk default!")
	
func update(delta : float):
	pass
	
func physics_Update(delta : float):
	($"../.." as Player).moving()
	
func transition_manager():
	pass
