extends state_machine
class_name Enemy1_Search

const SPEED = 3.0

var last_seen:Vector3

@onready var enemy:CharacterBody3D = owner

func Enter(args:Array):
	last_seen = args[0]
	enemy.spd = SPEED

func Physics_update(_delta:float):
	enemy.target_pos = last_seen

func _on_detection_detection_entered(entity):
	Transitioned.emit(self,"Enemy1_Everything",[entity])

func _on_enemy_1_target_reached() -> void:
	last_seen = Vector3.ZERO
	Transitioned.emit(self,"Enemy1_Wander",[])
