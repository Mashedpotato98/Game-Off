extends state_machine
class_name PlayerWalk

@export var player:CharacterBody3D
@export var spring_arm:SpringArm3D
 

var speed:int = 300
var jump:int = 5
var gravity:int = 40

func update(_delta:float):
	if not player.is_on_floor():
		player.velocity.y -= gravity

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		player.velocity.y = jump

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)

	player.move_and_slide()
	
	spring_arm.position = player.position
