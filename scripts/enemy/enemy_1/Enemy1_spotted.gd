extends state_machine
class_name Enemy1_Everything

var target = null

@export var enemy:CharacterBody3D

var spd:int = 40
var grav:int = 500

func Physics_update(_delta:float):
	if target != null:
		enemy.position += (target.position - enemy.position) / spd

	enemy.move_and_slide()

func _on_detection_area_entered(area):
	target = area

func _on_detection_area_exited(area):
	target = null
