extends state_machine
class_name Enemy1_Wander

const SPEED = 1.5

@export_flags_3d_physics var wall_detector_mask

var wander_point:Vector3 = Vector3.ZERO
var grav:float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var enemy:CharacterBody3D = owner

func Enter(_args:Array):
	wander_point = pick_wander_point()
	enemy.spd = SPEED

func Physics_update(_delta:float):
	enemy.target_pos = wander_point

func pick_wander_point() -> Vector3:
	var result = enemy.global_position
	var wander_points = get_tree().get_nodes_in_group("wander_points")
	wander_points.shuffle()

	var ray = RayCast3D.new()
	ray.collision_mask = wall_detector_mask
	add_sibling(ray)

	for point in wander_points:
		var wander_point_pos: Vector3 = point.global_position
		ray.target_position = enemy.to_local(wander_point_pos)
		ray.force_raycast_update()
		if not ray.is_colliding():
			result = wander_point_pos
			break

	ray.free()
	return result

func _on_detection_detection_entered(entity):
	Transitioned.emit(self,"Enemy1_Everything",[entity])

func _on_enemy_1_target_reached() -> void:
	# Note: This could call even when the enemy isn't wandering.
	wander_point = pick_wander_point()
