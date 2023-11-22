extends CharacterBody3D

signal target_reached

var grav:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var rot_spd:float = 5.0
var target_pos:Vector3 = Vector3.ZERO
var spd:float = 0.0
var desired_dist:float = 0.25

@onready var state_label = $StateLabel
@onready var machine = $"state machine"
@onready var nav_agent = $NavigationAgent3D

func _physics_process(delta:float):
	if is_on_floor():
		if global_position.distance_to(target_pos) > desired_dist:
			printt(global_position.distance_to(target_pos),desired_dist)
			var y = velocity.y
			nav_agent.target_position = target_pos
			velocity = global_position.direction_to(nav_agent.get_next_path_position())*spd
			print(global_position.direction_to(nav_agent.get_next_path_position()))
			velocity.y = y
		else:
			print("reached")
			velocity = Vector3.ZERO
			target_reached.emit()
	else:
		print("falling")
		velocity.y -= grav*delta

	move_and_slide()

	turn(delta)
	state_label.text = machine.current_state.name


func turn(delta:float):
	var flat_vel := velocity
	flat_vel.y = 0
	if flat_vel.length() > 0:
		quaternion = quaternion.slerp(Basis.looking_at(velocity).get_rotation_quaternion(),rot_spd*delta)
