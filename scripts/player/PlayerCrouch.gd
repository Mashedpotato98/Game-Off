extends state_machine
class_name PlayerCrouch

@export var player:CharacterBody3D
@export var head:Node3D
@export var ray:RayCast3D

var crouch_speed:int = 150
var lerp_speed:int = 50
var gravity:int = 40

var crouch_depth = 0.3
var crouch_lerp = 0.1

@export var crouch_collision:CollisionShape3D
@export var standing_collision:CollisionShape3D

var direction = Vector3.ZERO

func Enter():
	crouch_collision.disabled = false
	standing_collision.disabled = true
	ray.enabled = true

func update(_delta:float):
	head.position.y = lerp(head.position.y,4.8-crouch_depth,crouch_lerp)
	if not player.is_on_floor():
		player.velocity.y -= gravity

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = lerp(direction,(player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),_delta*lerp_speed)
	
	if direction:
		player.velocity.x = direction.x * crouch_speed
		player.velocity.z = direction.z * crouch_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, crouch_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, crouch_speed)

	player.move_and_slide()

	if not Input.is_action_pressed("Crouch") and ray.is_colliding() == false:
		head.position.y = lerp(head.position.y,4.8,crouch_lerp)
		crouch_collision.disabled = true
		standing_collision.disabled = false
		ray.enabled = false

		Transitioned.emit(self,"PlayerWalk")

	if Input.is_action_just_pressed("Sprint") and ray.is_colliding() == false:
		head.position.y = lerp(head.position.y,4.8,crouch_lerp)
		crouch_collision.disabled = true
		standing_collision.disabled = false
		ray.enabled = false

		Transitioned.emit(self,"PlayerSprint")
