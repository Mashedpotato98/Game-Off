extends PlayerMovement
class_name PlayerCrouch

@export var head:Node3D
@export var ray:RayCast3D

@onready var default_depth = head.position.y
var crouch_depth = 0.5
var crouch_lerp = 10.0

@export var crouch_collision:CollisionShape3D
@export var standing_collision:CollisionShape3D

func Enter(_args:Array):
	# Use set_defered() to make it physics safe
	crouch_collision.set_deferred("disabled",false)
	standing_collision.set_deferred("disabled",true)
	ray.enabled = true

func update(delta:float):
	head.position.y = lerp(head.position.y,default_depth-crouch_depth,crouch_lerp*delta)
	handle_transitions()

func handle_transitions():
	if ray.is_colliding() == false:
		if not Input.is_action_pressed("Crouch"):
			get_up()
			Transitioned.emit(self,"PlayerWalk",[])

		if Input.is_action_just_pressed("Sprint"):
			get_up()
			Transitioned.emit(self,"PlayerSprint",[])

func get_up():
	var get_up_time:float = 0.1
	get_tree().create_tween().tween_property(head,"position:y",default_depth,get_up_time)

	crouch_collision.set_deferred("disabled",true)
	standing_collision.set_deferred("disabled",false)
	ray.enabled = false
