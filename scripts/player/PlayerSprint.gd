extends state_machine
class_name PlayerSprint

@export var player:CharacterBody3D
 
var sprint_speed:int = 360
var lerp_speed:int = 60
var jump:int = 5
var gravity:int = 40

var direction = Vector3.ZERO

func update(_delta:float):
	if not player.is_on_floor():
		player.velocity.y -= gravity

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction,(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),_delta*lerp_speed)

	if direction:
		player.velocity.x = direction.x * sprint_speed
		player.velocity.z = direction.z * sprint_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, sprint_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, sprint_speed)

	player.move_and_slide()

	if not Input.is_action_pressed("Sprint"):
		Transitioned.emit(self,"PlayerWalk")

	if Input.is_action_just_pressed("Crouch"):
		Transitioned.emit(self,"PlayerCrouch")

