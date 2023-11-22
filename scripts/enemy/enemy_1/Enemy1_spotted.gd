extends state_machine
class_name Enemy1_Everyenemything

const SPEED = 3.0

@export var enemy:CharacterBody3D

var target:Node3D = null
var spd:int = 3

func Enter(args:Array):
	target = args[0]
	enemy.spd = SPEED

func Physics_update(_delta:float):
	enemy.target_pos = target.global_position

func _on_detection_detection_exited() -> void:
	Transitioned.emit(self,"Enemy1_Search",[target.global_position])
	target = null
