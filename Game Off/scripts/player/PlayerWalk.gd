extends state_machine
class_name PlayerWalk

@export var player:CharacterBody2D
@export var anim:AnimationPlayer
 

var current_character = "aang %s"


const speed = 300
const jump = -400

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func update(_delta:float):
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * _delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		player.velocity.x = direction * speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)

	player.move_and_slide()
