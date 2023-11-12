extends state_machine
class_name Enemy1_Walk

var player = null

@export var nav_agent:NavigationAgent3D
@export var enemy:CharacterBody3D

var spd:int = 40
var grav:int = 500

func Physics_update(_delta:float):
	if player != null:
		enemy.position += (player.position - enemy.position) / spd

	enemy.move_and_slide()

func _on_detection_body_entered(body):
	player = body

func _on_detection_body_exited(body):
	player = null
