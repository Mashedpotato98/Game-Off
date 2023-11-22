# Base class for player movement
extends state_machine
class_name PlayerMovement

# Note: It might also be possible to use 'owner', But I'm not sure.
@export var player:CharacterBody3D
@export var hand_anim:AnimationPlayer

@export var move_anim_name:String = ""
@export var idle_anim_name:String = "Idle"
@export var speed:float = 2
@export var jump:float = 5

var lerp_speed:int = 10
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead_zone:float = 0.1

var direction = Vector3.ZERO

func Physics_update(delta:float):
	handle_gravity(delta)
	handle_direction(delta)
	player.move_and_slide()

func handle_gravity(delta:float):
	if not player.is_on_floor():
		player.velocity.y -= gravity*delta
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y = jump

func handle_direction(delta:float):
	# Input.get_vector() returns a vector with a length limited to 1. No need to normalize.
	var input_dir = Input.get_vector("Strafe_left", "Strafe_right", "Forward", "Backward")
	# Prevent stick drift
	if input_dir.length() <= dead_zone:
		input_dir = Vector2.ZERO
	direction = lerp(direction,(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)),delta*lerp_speed)

	if direction:
		player.velocity.x = direction.x * speed
		player.velocity.z = direction.z * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		player.velocity.z = move_toward(player.velocity.z, 0, speed)

	animate(input_dir)

func animate(input_dir:Vector2):
	# Bad code
	if hand_anim.is_playing() and hand_anim.current_animation.begins_with("Camera"):
		return

	var anim = idle_anim_name#move_anim_name if input_dir else idle_anim_name
	if hand_anim.has_animation(anim):
		hand_anim.play(anim, 0.5)
