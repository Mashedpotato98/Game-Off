extends state_machine
class_name PlayerWalk

@export var player:CharacterBody3D
@export var hand_anim:AnimationPlayer

var speed:int = 300
var lerp_speed:int = 150
var jump:int = 5
var gravity:int = 40

var direction = Vector3.ZERO

func Physics_update(_delta:float): 
	if not player.is_on_floor():
		player.velocity.y -= gravity

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction,(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),_delta*lerp_speed)
	
	if direction:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
		hand_anim.play("Walk")
	else:
		hand_anim.play("Idle")
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)

	player.move_and_slide()

	if Input.is_action_just_pressed("Crouch"):
		Transitioned.emit(self,"PlayerCrouch")
	else:
		if Input.is_action_just_pressed("Sprint") and direction:
			Transitioned.emit(self,"PlayerSprint")
