extends PlayerMovement
class_name PlayerWalk

func update(_delta:float):
	if Input.is_action_just_pressed("Crouch"):
		Transitioned.emit(self,"PlayerCrouch")
	elif Input.is_action_just_pressed("Sprint") and direction:
		Transitioned.emit(self,"PlayerSprint")
