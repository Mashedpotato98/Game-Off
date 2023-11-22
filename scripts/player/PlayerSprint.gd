extends PlayerMovement
class_name PlayerSprint

func update(_delta:float):
	if not Input.is_action_pressed("Sprint"):
		Transitioned.emit(self,"PlayerWalk",[])

	if Input.is_action_just_pressed("Crouch"):
		Transitioned.emit(self,"PlayerCrouch",[])
