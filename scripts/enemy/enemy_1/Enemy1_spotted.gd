extends state_machine
class_name Enemy1_Walk

var player = null

@export var nav_agent:NavigationAgent3D
@export var enemy:CharacterBody3D
@export var player_path:NodePath

var spd:int = 400
var grav:int = 500

func Enter():
	player = get_node(player_path)

func Physics_update(_delta:float):
	enemy.velocity = Vector3.ZERO
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	enemy.velocity = (next_nav_point - enemy.global_transform.origin).normalized() * spd
	
	enemy.move_and_slide()

